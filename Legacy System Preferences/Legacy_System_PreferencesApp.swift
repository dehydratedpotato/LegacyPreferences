//
//  Legacy_System_PreferencesApp.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Doing this to get rid of uneeded menuitems.
    // Not the best but swift makes it stupid, so...
    func applicationWillUpdate(_ notification: Notification) {
        if let menu = NSApplication.shared.mainMenu {
            if let file = menu.items.first(where: { $0.title == "File"}) {
                menu.removeItem(file);
            }
            if let view = menu.items.first(where: { $0.title == "View"}) {
                menu.removeItem(view)
            }
        }
    }
}

@main
struct Legacy_System_PreferencesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var manager: PaneManager
    
    private let displayname = "Legacy System Preferences"
    
    init() {
        self._manager = .init(wrappedValue: .shared)
    }
    
    var body: some Scene {
        let search = SearchField("Search", text: $manager.searchQuery)
        
        WindowGroup {
            HomeView(manager: manager)
                .fixedSize()
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Button {
                            backwards()
#if DEBUG
                            print(manager.backwardsHistory.count)
#endif
                        } label: {
#if DEBUG
                            Label("Back", systemImage: "chevron.left")
#endif
                        }
                        .disabled(!manager.backwardNavigationReady)
                        
                        Button {
                            forwards()
                            print(manager.forwardsHistory.count)
                        } label: {
                            Label("Forwards", systemImage: "chevron.right")
                        }
                        .disabled(!manager.forwardNavigationReady)
                        
                        if !manager.isEditing {
                            Button {
                                showAll()
                            } label: {
                                Label("Home", systemImage: "square.grid.4x3.fill")
                            }
                        } else {
                            Button("Done") {
                                withAnimation(.linear(duration: 0.1)) {
                                    manager.isEditing.toggle()
                                }
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .primaryAction) {
                        search
                            .frame(width: 165)
                    }
                }
        }
        .windowResizability(.contentSize)
        .commands {
            CommandMenu("View ") { // extra space to stop delegate from removing
                Button("Back") { backwards() }
                    .keyboardShortcut("[")
                    .disabled(!manager.backwardNavigationReady)
                
                Button("Forwards") { forwards() }
                    .keyboardShortcut("]")
                    .disabled(!manager.forwardNavigationReady)
                
                Button("Show All Preferences") {
                    showAll()
                }.keyboardShortcut("l")
                
                Button("Customize...") {
                    withAnimation(.linear(duration: 0.1)) {
                        manager.isEditing.toggle()
                    }
                }
                
                Picker(selection: $manager.shouldGroup) {
                    Text("Organize by Categories").tag(0)
                    Text("Organize by Alphabetically").tag(1)
                } label: {}
                    .pickerStyle(.inline)
                
                Button("Search") {
                    search.field.window?.makeFirstResponder(search.field)
                }.keyboardShortcut("f")
                
                Divider()
                
                ForEach(manager.allPanes()) { pane in
                    Button {
                        _ = manager.openPane(pane: pane)
                    } label: {
                        HStack {
                            pane.appIcon
                            Text(pane.name)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func showAll() {
        if manager.currentPane.id != "home" {
            NSApp.mainWindow?.title = displayname
            manager.currentPane = PaneItem(id: "home", name: "", appIcon: nil, path: "", priority: 0, section: .none)
            manager.accesslayer.attempClosePreference()
            
            withAnimation(.linear(duration: 0.25)) {
                manager.selectedPane = nil
            }
        }
    }
    
    private func gotoShowAll() {
        manager.backwardsHistory.append(manager.currentPane)
        showAll()
    }
    
    private func validateNav() {
        manager.backwardNavigationReady = manager.backwardsHistory.count != 0
        manager.forwardNavigationReady = manager.forwardsHistory.count != 0
    }
    
    private func backwards() {
#if DEBUG
        print("Navigating backwards... \(manager.backwardsHistory)")
#endif
        if manager.backwardsHistory.count > 0 {
            if let idx = manager.backwardsHistory.indices.last {
                manager.forwardsHistory.append(manager.currentPane)
                
                if manager.backwardsHistory[idx].id == "home" {
                    showAll()
                } else {
                    if manager.currentPane.id != "home" {
                        manager.accesslayer.attempClosePreference()
                    }
                    
                    _ = manager.openPane(pane: manager.backwardsHistory[idx])
                }
                
                manager.backwardsHistory.remove(at: idx)
                validateNav()
            }
        }
    }
    
    private func forwards() {
#if DEBUG
        print("Navigating forwards... \(manager.forwardsHistory)")
#endif
        if manager.forwardsHistory.count > 0 {
            if let idx = manager.forwardsHistory.indices.last {
                manager.backwardsHistory.append(manager.currentPane)
                
                if manager.forwardsHistory[idx].id == "home" {
                    showAll()
                } else {
                    if manager.currentPane.id != "home" {
                        manager.accesslayer.attempClosePreference()
                    }
                    
                    _ = manager.openPane(pane: manager.forwardsHistory[idx])
                }
                
                manager.forwardsHistory.remove(at: idx)
                validateNav()
            }
        }
    }
}
