//
//  PaneHandler.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import SwiftUI
import LocalAuthentication

let dir = "/Library/LegacyPrefPanes"

enum PaneSection: Int {
    case primary = 0
    case secondary = 1
    case tertiary = 3
}

struct PaneItem: Identifiable {
    let id:      String
    let name:    String
    let image:   Image?
    let path:    String
    let pri:     Int32
    var section: PaneSection
    var visible: Bool = true
    var customizable: Bool = true
}

class PaneHandler: ObservableObject
{
    // MARK: - Properties
    
    @Published var collection: [PaneItem] = [PaneItem]() // main grid
    @Published var header:     [PaneItem] = [PaneItem]() // heading grid
    @Published var group:            Bool
    @Published var hasTertiaryItems: Bool = false
    @Published var hasSecondaryItems:Bool = false
    @Published var editing:          Bool = false
    
    var manager:              PaneManager = PaneManager()
    var forwardsHistory:         [String] = []
    var backwardsHistory:        [String] = ["showall"]
    var currentPane:               String = "showall"
    let exclusion:               [String] = [AppleBundleIDs.Classroom.rawValue, // <-- excluding temporarily
                                             AppleBundleIDs.ClassKit.rawValue, // <-- excluding temporarily
                                             AppleBundleIDs.DigiHubDiscs.rawValue, // <-- excluding until can check IOKit
                                             AppleBundleIDs.FibreChannel.rawValue,  // <-- excluding until can check IOKit
                                             AppleBundleIDs.Profiles.rawValue] // <-- excluding temporarily
    
    // MARK: - Lifecycle and Methods
    
    init() {
        group = UserDefaults.standard.object(forKey: "Group") != nil ? UserDefaults.standard.bool(forKey: "Group") : true
        update(excluding: exclusion)
    }
    
    func update(excluding: [String])
    {
        collection = [PaneItem]()
        header     = [PaneItem]()
        
        let fileManager = FileManager()
        do {
            let files = try fileManager.contentsOfDirectory(atPath: dir)
            for file in files {
                if file.contains(".prefPane") {
                    var image: Image
                    var name:  String
                    var pri:   Int32       = INT_MAX
                    var sect:  PaneSection = .tertiary
                    let path:  String      = "\(dir)/\(file)"
                    let id:    String      = Bundle(path: path)?.bundleIdentifier ?? "\(UUID())"
                    
                    // check exclude panes
                    if excluding.contains(id) {
                        print("Skipped \(file) due to exclusion")
                        continue
                    }
                    
                    // check device for battery
                    if id == AppleBundleIDs.Battery.rawValue || id == AppleBundleIDs.EnergySaver.rawValue {
                        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPMPowerSource"))
                        let installed = IORegistryEntryCreateCFProperty(service, "BatteryInstalled" as CFString?, kCFAllocatorDefault, 0)
                        
                        if id == AppleBundleIDs.Battery.rawValue {
                            if installed?.takeRetainedValue() as! Bool == false {
                                print("Skipped \(file), device has no battery")
                                continue
                            }
                        } else {
                            if installed?.takeRetainedValue() as! Bool == true {
                                print("Skipped \(file), device has a battery")
                                continue
                            }
                        }
                    }
                    
                    // check device for biometrics
                    if id == AppleBundleIDs.TouchID.rawValue {
                        if !LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                            print("Skipped \(file), device has no biometrics")
                            continue
                        }
                    }
                    
                    // pull data from Info.plist
                    if let plist = Bundle(path: path)?.infoDictionary {
                        // check stored IOService
                        if let asset = plist["NSPrefPaneIOServiceToMatch"] as? String {
                            if IOServiceMatching(asset) == nil {
                                print("Skipped \(file), pane does not apply to system abilities")
                                continue
                            }
                        }
                        
                        // get proper name string for pane
                        if let asset = plist["CFBundleName"] as? String {
                            name = asset
                        } else if let asset = plist["NSPrefPaneIconLabel"] as? String {
                            name = asset
                        } else {
                            name = file.replacing(".prefPane", with: "")
                        }
                        
                        // get proper icon for pane
                        if let asset = plist["NSPrefPaneIconName"] as? String {
                            image = Image(asset, bundle: Bundle(path: path))
                        } else if let asset = plist["CFBundleIconFile"] as? String {
                            let url = URL(fileURLWithPath: "\(path)/Contents/Resources/\(asset)")
                            
                            if let nsimage = NSImage(contentsOf: url) {
                                image = Image(nsImage: nsimage)
                            } else {
                                print("Skipped \(file), no icon found")
                                continue
                            }
                        } else if let asset = plist["NSPrefPaneIconFile"] as? String {
                            image = Image(asset, bundle: Bundle(path: path))
                        } else {
                            print("Skipped \(file), no icon found")
                            continue
                        }
                    } else {
                        print("Skipped \(file), no Info.plist found")
                        continue
                    }
                    
                    // generate the priority based on bundle ID
                    for i in AppleBundleIDs.allCases {
                        if id == i.rawValue {
                            for (key, value) in bundlePriority {
                                if key.rawValue == id {
                                    pri = value
                                    break
                                }
                            }
                        }
                    }
                    
                    // decide which section to render in
                    if pri != INT_MAX && pri > 17 {
                        sect = .secondary
                    } else if pri <= 17 {
                        sect = .primary
                    }
                    
                    // this isn't the cleanest but it works
                    if id == AppleBundleIDs.Dock.rawValue {
                        name = "Dock & Menu Bar"
                    }
                    if id == AppleBundleIDs.Siri.rawValue {
                        name = "Siri"
                    }
                    if id == AppleBundleIDs.Security.rawValue {
                        name = "Security & Privacy"
                    }
                    if id == AppleBundleIDs.StartupDisk.rawValue {
                        name = "Startup\nDisk"
                    }
                    
                    // specifaclly checking for Apple ID and Family Sharing,
                    // that way we may set them in the top grid
                    if id == AppleBundleIDs.AppleID.rawValue {
                        header.append(PaneItem(id: id, name: "Apple ID", image: image, path: path, pri: pri, section: sect, customizable: false))
                    } else if id == AppleBundleIDs.FamilySharing.rawValue {
                        header.append(PaneItem(id: id, name: "Family Sharing", image: image, path: path, pri: pri, section: sect, customizable: false))
                    } else {
                        // we also look for sw update beacuse the pane already has a CFBundleName,
                        // it just doesn't contain proper spaces and I'm not messing with that data
                        if id == AppleBundleIDs.SoftwareUpdate.rawValue {
                            collection.append(PaneItem(id: id, name: "Software Update", image: image, path: path, pri: pri, section: sect))
                        } else {
                            collection.append(PaneItem(id: id, name: name, image: image, path: path, pri: pri, section: sect))
                        }
                    }
                }
            }
        } catch {
            print(error)
            return
        }
        
        sort()
        checkItems()
    }
    
    func sort() {
        header = header.sorted(by: { $0.pri < $1.pri })
        
        if group {
            collection = collection.sorted(by: { $0.pri < $1.pri })
        } else {
            collection = collection.sorted(by: { $0.name < $1.name })
            for i in 0..<collection.count {
                collection[i].section = .primary
            }
        }
    }
    
    func checkItems() {
        hasTertiaryItems = false
        hasSecondaryItems = false
        
        for item in collection {
            if item.section == .tertiary {
                hasTertiaryItems = true
            }
            if item.section == .secondary {
                hasSecondaryItems = true
            }
        }
    }
    
    func getUserAvatar() -> Image {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "dscl . read /Users/\(NSUserName()) JPEGPhoto | tail -1 | xxd -r -p "]
        
        let out = Pipe()
        task.standardOutput = out
        task.launch()
        let outData = out.fileHandleForReading.readDataToEndOfFile()

        if let img = NSImage(data: outData) {
            return Image(nsImage: img)
        } else {
            return Image(systemName:"person.circle.fill")
        }
    }
}
