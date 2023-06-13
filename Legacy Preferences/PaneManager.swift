//
//  PaneManager.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI
import AppearancePane
import MissionControlPane
//import DockAndMenuPane
//import AccessibilityPane

final class PaneManager: ObservableObject {
    static let shared: PaneManager = .init()
    
    static let shouldGroupPanesKey = "shouldGroupPanes"
    static let hiddenPaneListKey = "hiddenPaneLis"
    
    struct PrioritizedPaneItem: Identifiable {
        let type: PaneConstants.PaneType
        let id: UInt32
    }
    
    @Published var isEditing: Bool = false
    @Published var searchQuery: String = ""
    
    @Published var allPanes: [PrioritizedPaneItem] = []
    @Published var primaryPaneList: [PrioritizedPaneItem] = []
    @Published var secondaryPaneList: [PrioritizedPaneItem] = []
//    @Published var tertiaryPaneList: [PaneConstants.PaneType] = []
    
    @Published private(set) var currentPane: PaneConstants.PaneType? // nil means no open pane
    
    @Published var hiddenPanes: [Int] = []
    @Published var shouldGroup: Bool = true {
        didSet {
            UserDefaults.standard.set(self.shouldGroup, forKey: PaneManager.shouldGroupPanesKey)
        }
    }
    
    var paneHistory: [PaneConstants.PaneType?] = [nil]
    private var paneHistoryPosition: Int = 0
    
    var historyCanMoveForward: Bool {
        return self.paneHistoryPosition < (self.paneHistory.count - 1)
    }
    
    var historyCanMoveBackward: Bool {
        return self.paneHistoryPosition > 0
    }
    
    // MARK: Lifecycle
    
    init() {
        if let _ = UserDefaults.standard.object(forKey: PaneManager.shouldGroupPanesKey) {
            self.shouldGroup = UserDefaults.standard.bool(forKey: PaneManager.shouldGroupPanesKey)
        }
        
        if let _ = UserDefaults.standard.object(forKey: PaneManager.hiddenPaneListKey) {
            self.hiddenPanes = UserDefaults.standard.array(forKey: PaneManager.hiddenPaneListKey) as! [Int]
        }
        
        for pane in PaneConstants.PaneType.allCases where pane != .appleID && pane != .familySharing {
            let priority: UInt32 = PaneConstants.priTable[pane.rawValue]
            
            if priority != UInt32.max && priority > 17 {
                self.secondaryPaneList.append(.init(type: pane, id: priority))
            } else {
                self.primaryPaneList.append(.init(type: pane, id: priority))
            }
            
            self.allPanes.append(.init(type: pane, id: priority))
        }
        
        self.primaryPaneList = self.primaryPaneList.sorted(by: { $0.id < $1.id })
        self.secondaryPaneList = self.secondaryPaneList.sorted(by: { $0.id < $1.id })
        
        self.allPanes = self.allPanes.sorted(by: {
            let name0 = PaneConstants.nameTable[$0.type.rawValue]
            let name1 = PaneConstants.nameTable[$1.type.rawValue]
            return name0 < name1
        })
        
        Logger.log("sorted \(self.allPanes.count) panes (\(self.primaryPaneList.count) primary, \(self.secondaryPaneList.count) secondary)", class: Self.self)
    }
    
    // MARK: Methods
    
    func setPane(type: PaneConstants.PaneType, toVisibility value: Bool) {
        if let idx = self.hiddenPanes.firstIndex(of: type.rawValue) {
            self.hiddenPanes.remove(at: idx)
        } else {
            self.hiddenPanes.append(type.rawValue)
        }

        UserDefaults.standard.set(self.hiddenPanes, forKey: PaneManager.hiddenPaneListKey)
        
        Logger.log("set pane \"\(PaneConstants.nameTable[type.rawValue])\" visibilty to \(value)", class: Self.self)
    }
    
    func setPane(to pane: PaneConstants.PaneType?) {
        self.currentPane = pane
        self.paneHistory.append(pane)
        self.paneHistoryPosition = self.paneHistory.count - 1
        
        // TODO: Cap max allowed entrees in pane history?
        
        Logger.log("launched pane \"\(String(describing: pane))\"", class: Self.self)
    }
    
    func historyForward() {
        self.paneHistoryPosition += 1
        self.currentPane = self.paneHistory[self.paneHistoryPosition]
    }
    
    func historyBackward() {
        self.paneHistoryPosition -= 1
        self.currentPane = self.paneHistory[self.paneHistoryPosition]
    }
    
    @ViewBuilder func getView(ofPane index: PaneConstants.PaneType) -> some View {
        switch(index) {
            
            // available
        case .appearance:
            AppearancePane.PaneView()
            
        case .missionControl:
            MissionControlPane.PaneView()

            // unavailable
        case .startupDisk:
            StartupDiskPane()
        case .screenTime:
            ScreenTimePane()
        case .softwareUpdate:
            SoftwareUpdatePane()
        case .timeMachine:
            TimeMachinePane()
        case .appleID:
            AppleIDPane()
        case .familySharing:
            FamilySharingPane()
            
        default:
            EmptyView()
        }
    }
}
