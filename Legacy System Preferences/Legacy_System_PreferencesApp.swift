//
//  Legacy_System_PreferencesApp.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

let displayname = "Legacy System Preferences"

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
    @ObservedObject var manager = PaneManager()

    var body: some Scene {
        let search = SearchField("Search", text: $manager.query)
        
        WindowGroup {
            HomeView(manager: manager)
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Button {
                            backwards()
                            print(manager.backwardsHistory.count)
                        } label: {
                            Label("Back", systemImage: "chevron.left")
                        }
                        .disabled(!manager.backready)
                        
                        Button {
                            forwards()
                            print(manager.forwardsHistory.count)
                        } label: {
                            Label("Forwards", systemImage: "chevron.right")
                        }
                        .disabled(!manager.forwardready)
                        
                        if !manager.editing {
                            Button {
                                showAll()
                            } label: {
                                Label("Home", systemImage: "square.grid.4x3.fill")
                            }
                        } else {
                            Button("Done") {
                                withAnimation(.linear(duration: 0.1)) {
                                    manager.editing.toggle()
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
                    .disabled(!manager.backready)
                
                Button("Forwards") { forwards() }
                    .keyboardShortcut("]")
                    .disabled(!manager.forwardready)
                
                Button("Show All Preferences") {
                    showAll()
                }.keyboardShortcut("l")
                
                Button("Customize...") {
                    withAnimation(.linear(duration: 0.1)) {
                        manager.editing.toggle()
                    }
                }
                
                Picker(selection: $manager.group) {
                    Text("Organize by Categories").tag(0)
                    Text("Organize by Alphabetically").tag(1)
                } label: {}
                    .pickerStyle(.inline)
                
                Button("Search") {
                    search.field.window?.makeFirstResponder(search.field)
                }.keyboardShortcut("f")
//                    .disabled(true)
                
                Divider()
                
                ForEach(manager.allPanes()) { pane in
                    Button {
                        manager.openPane(pane: pane)
                    } label: {
                        HStack {
                            pane.image
                            Text(pane.name)
                        }
                    }
                }
            }
        }
        
    }
    
    func showAll() {
        if manager.currentPane.id != "home" {
            NSApp.mainWindow?.title = displayname
            manager.currentPane = PaneItem(id: "home", name: "", image: nil, path: "", pri: 0, section: .none)
            manager.accesslayer.attempClosePreference()
            
            withAnimation(.linear(duration: 0.25)) {
                manager.currentView = nil
            }
        }
    }

    func gotoShowAll() {
        manager.backwardsHistory.append(manager.currentPane)
        showAll()
    }

    func validateNav() {
        if manager.backwardsHistory.count == 0 {
            manager.backready = false
        } else {
            manager.backready = true
        }
        if manager.forwardsHistory.count == 0 {
            manager.forwardready = false
        } else {
            manager.forwardready = true
        }
    }
    
    func backwards() {
        print("Navigating backwards... \(manager.backwardsHistory)")
        
        if manager.backwardsHistory.count > 0 {
            if let idx = manager.backwardsHistory.indices.last {
                manager.forwardsHistory.append(manager.currentPane)
                
                if manager.backwardsHistory[idx].id == "home" {
                    showAll()
                } else {
                    if manager.currentPane.id != "home" {
                        manager.accesslayer.attempClosePreference()
                    }
                    
                    manager.openPane(pane: manager.backwardsHistory[idx])
                }
                
                manager.backwardsHistory.remove(at: idx)
                validateNav()
            }
        }
    }

    func forwards() {
        print("Navigating forwards... \(manager.forwardsHistory)")
        
        if manager.forwardsHistory.count > 0 {
            if let idx = manager.forwardsHistory.indices.last {
                manager.backwardsHistory.append(manager.currentPane)
                
                if manager.forwardsHistory[idx].id == "home" {
                    showAll()
                } else {
                    if manager.currentPane.id != "home" {
                        manager.accesslayer.attempClosePreference()
                    }
                    
                    manager.openPane(pane: manager.forwardsHistory[idx])
                }
            
                manager.forwardsHistory.remove(at: idx)
                validateNav()
            }
        }
    }
}
