//
//  PaneManager.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI
import LocalAuthentication

public final class PaneManager: ObservableObject {
    public static let shared:              PaneManager = PaneManager()
    public static let searchedDirectories: [String] = ["/Library/PreferencePanes", "/Library/LegacyPrefPanes"]
    
    @Published public var collection: [PaneItem] = [] // main grid
    @Published public var header:     [PaneItem] = [] // heading grid
    @Published public var shouldGroup: Int
    
    @Published public var hasItems: (Bool, Bool, Bool) = (false, false, false)
    
    @Published public var isEditing:    Bool = false
    @Published public var searchQuery:  String = ""
    @Published public var selectedPane: PaneView?
    
    @Published public var backwardNavigationReady = false
    @Published public var forwardNavigationReady  = false
    
    public var accesslayer:     PaneAccessLayer = PaneAccessLayer()
    public var forwardsHistory:  [PaneItem] = []
    public var backwardsHistory: [PaneItem] = []
    public var currentPane:      PaneItem
    public var hiddenPanes:      [String] = []
    
    // temporarily excluding these until proper checks can be made
    private lazy var excludedPanes: [String] = [BundleData.Identifiers.Classroom.rawValue,
                                                BundleData.Identifiers.ClassKit.rawValue,
                                                BundleData.Identifiers.DigiHubDiscs.rawValue,
                                                BundleData.Identifiers.FibreChannel.rawValue,
                                                BundleData.Identifiers.Profiles.rawValue]
    
    public lazy var allKeywords: [String : [String]] = {
        var dictionary: [String : [String]] = [:]
        
        for item in self.collection {
            let keywords = item.keywords
            
            for (key, value) in keywords {
                if let key = key as? String, let value = value as? String {
                    dictionary.updateValue(value.components(separatedBy: ", "), forKey: key)
                }
            }
        }
        
        for item in self.header {
            let keywords = item.keywords
            
            for (key, value) in keywords {
                if let key = key as? String, let value = value as? String {
                    dictionary.updateValue(value.components(separatedBy: ", "), forKey: key)
                }
            }
        }
        
        return dictionary
    }()
    
    // MARK: - Lifecycle
    
    init() {
        self.currentPane = PaneItem(id: "home",
                                    name: "",
                                    appIcon: nil,
                                    path: "",
                                    priority: 0,
                                    section: .none)
        
        self.shouldGroup = UserDefaults.standard.object(forKey: "Group") != nil ? UserDefaults.standard.integer(forKey: "Group") : 0
        self.update()
        
        if let array = UserDefaults.standard.array(forKey: "Hidden") as? [String] {
            self.hiddenPanes = array
        }
        
#if DEBUG
        print("*** [PaneManager] Init with panes \(collection), \(header)")
#endif
    }
    
    // MARK: - Public Methods
    
    public final func update() {
        var collectionArray: [PaneItem] = []
        var headerArray: [PaneItem] = []
        
        for dir in PaneManager.searchedDirectories {
            guard let files = try? FileManager.default.contentsOfDirectory(atPath: dir) else {
                continue
            }
            
            for file in files where file.contains(".prefPane") {
                let path = "\(dir)/\(file)"
                let id = Bundle(path: path)?.bundleIdentifier ?? "\(UUID())"
                
                // skip if these are matched
                
                guard
                    let plist = Bundle(path: path)?.infoDictionary,
                    !self.excludedPanes.contains(id)
                else {
                    continue
                }
                
                if let asset = plist["NSPrefPaneIOServiceToMatch"] as? String, IOServiceMatching(asset) == nil {
                    continue
                }
                
                if id == BundleData.Identifiers.Battery.rawValue || id == BundleData.Identifiers.EnergySaver.rawValue {
                    let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMPowerSource"))
                    let installed = IORegistryEntryCreateCFProperty(service, "BatteryInstalled" as CFString?, kCFAllocatorDefault, 0)
                    
                    if let isInstalled = installed?.takeRetainedValue() as? Bool, !isInstalled {
                        continue
                    }
                }
                
                if id == BundleData.Identifiers.TouchID.rawValue &&
                    !LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                    continue
                }
                
                // get pane string
                
                var name: String = ""
                
                if let asset = plist["CFBundleName"] as? String {
                    name = asset
                } else if let asset = plist["NSPrefPaneIconLabel"] as? String {
                    name = asset
                } else {
                    name = file.replacing(".prefPane", with: "")
                }
                
                // get proper icon for pane
                
                var appIcon: Image
                
                if let asset = plist["NSPrefPaneIconName"] as? String {
                    appIcon = Image(asset, bundle: Bundle(path: path))
                } else if let asset = plist["CFBundleIconFile"] as? String {
                    let url = URL(fileURLWithPath: "\(path)/Contents/Resources/\(asset)")
                    
                    guard let nsimage = NSImage(contentsOf: url) else {
                        continue
                    }
                    
                    appIcon = Image(nsImage: nsimage)
                    
                } else if let asset = plist["NSPrefPaneIconFile"] as? String {
                    appIcon = Image(asset, bundle: Bundle(path: path))
                } else {
                    continue
                }
                
                // collect search term keywords
                
                let keywords: NSMutableDictionary = NSMutableDictionary()
                
                if let asset = plist["NSPrefPaneSearchParameters"] as? String,
                   let termsFile = Bundle(path: path)?.url(forResource: asset, withExtension: "searchTerms"),
                   let termDict = NSDictionary(contentsOf: termsFile) {
                    
                    for (_, value) in termDict {
                        if let strngArr = (value as? [String:NSArray])?["localizableStrings"], strngArr.count > 0 {
                            if let strngs = (strngArr[0] as? NSDictionary),
                               let index = strngs.value(forKey: "index") as? String,
                               let title = strngs.value(forKey: "title") as? String {
                                
                                keywords.setValue(index, forKey: title)
                            }
                        }
                    }
                }
                
                // get pane priority and section
                
                var priority: UInt8 = 255
                var section: PaneItem.Section = .tertiary
                
                for i in BundleData.Identifiers.allCases where id == i.rawValue {
                    for (key, value) in BundleData.priorityList where key.rawValue == id {
                        priority = value
                        
                        if priority != UInt8.max && priority > 17 {
                            section = .secondary
                        } else {
                            section = .primary
                        }
                        
                        continue
                    }
                }
                
                // add pane item
                
                var item = PaneItem(id: id, name: name, appIcon: appIcon, path: path, priority: priority, keywords: keywords, section: section)
                
                if let idCase = BundleData.Identifiers(rawValue: id),
                   BundleData.forceDefined.contains(where: { $0.key.rawValue == id }) {
                    
                    name = BundleData.forceDefined[idCase] ?? name
                    
                    item.name = name
                    
                    if id == BundleData.Identifiers.AppleID.rawValue || id == BundleData.Identifiers.FamilySharing.rawValue {
                        item.customizable = false
                        
                        headerArray.append(item)
                        
                        continue
                    }
                    
                    
                }
                
                collectionArray.append(item)
            }
        }
        
        self.collection = collectionArray
        self.header = headerArray
        
        self.sort()
        self.checkItems()
    }
    
    public final func openPane(pane: PaneItem) -> Bool {
        self.accesslayer.loadPreference(pane.path)
        
        guard self.accesslayer.applyViewFromPreference() else {
            return false
        }
        
        self.backwardsHistory.append(self.currentPane)
        self.currentPane = pane
        
        withAnimation(.linear(duration: 0.25)) {
            self.selectedPane = PaneView(pane: accesslayer.prefView)
        }
        
        NSApp.mainWindow?.title = pane.name
        self.backwardNavigationReady = true
        
        return true
    }
    
    public final func allPanes() -> [PaneItem] {
        var arr = self.header
        
        arr.append(contentsOf: self.collection)
        
        return arr.sorted(by: { $0.name < $1.name })
    }
    
    public final func returnSpotlightFocus(query: String, pane: PaneItem) -> Image {
        let panename  = pane.name.lowercased()
        let query     = query.lowercased()
        
        for (key, value) in pane.keywords {
            if let string = value as? String {
                let arr = string.split(separator: ", ")
                
                if panename == query {
                    return Image("spotlightmask")
                } else if panename.contains(query) {
                    return Image("spotlightdimmask")
                }
                
                for item in arr {
                    if item.lowercased() == query {
                        return Image("spotlightmask")
                    } else if item.lowercased().contains(query) {
                        return Image("spotlightdimmask")
                    }
                }
            }
            
            if let string = key as? String {
                if string.lowercased() == query {
                    return Image("spotlightmask")
                }
            }
        }
        
        return Image("filler")
    }
    
    // MARK: - Private Methods
    
    private func sort() {
        self.header = header.sorted(by: { $0.priority < $1.priority })
        
        if self.shouldGroup == 0 {
            self.collection = self.collection.sorted(by: { $0.priority < $1.priority })
        } else {
            self.collection = self.collection.sorted(by: { $0.name < $1.name })
            for i in self.collection.indices {
                collection[i].section = .primary
            }
        }
    }
    
    private func checkItems() {
        self.hasItems = (false, false, false)
        
        for item in self.collection {
            if item.section == .primary {
                self.hasItems.0 = true
            }
            
            if item.section == .secondary {
                self.hasItems.1 = true
            }
            
            if item.section == .tertiary {
                self.hasItems.2 = true
            }
        }
    }
}
