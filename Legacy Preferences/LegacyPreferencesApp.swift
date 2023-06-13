//
//  LegacyPreferencesApp.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/1/23.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    
    // Doing this to get rid of uneeded menuitems.
    // Not the best but swift makes it stupid, so...
    func applicationWillUpdate(_ notification: Notification) {
        DispatchQueue.main.async {
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
}

@main
struct LegacyPreferencesApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manager: PaneManager
    
    init() {
        self._manager = .init(wrappedValue: .shared)
    }
    
    var body: some Scene {
        let search = SearchField("Search", text: $manager.searchQuery)
        
        WindowGroup {
            PaneGridView(manager: manager)
                .fixedSize()
                .toolbar {
                    ToolbarItemGroup(placement: .navigation) {
                        Button(action: {
                            manager.historyBackward()
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                        .disabled(!manager.historyCanMoveBackward)
                        
                        Button(action: {
                            manager.historyForward()
                        }, label: {
                            Image(systemName: "chevron.right")
                        })
                        .disabled(!manager.historyCanMoveForward)
                        
                        if !manager.isEditing {
                            Button {
                                manager.setPane(to: nil)
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
                    
                    ToolbarItem() {
                        // TODO: Enable
                        search
                            .frame(width: 165)
                            .disabled(true)
                    }
                    
                }
        }
        .windowToolbarStyle(.unified)
        .windowResizability(.contentSize)
        .commands {
            CommandMenu("View ") { // extra space to stop delegate from removing
                Button("Back") {
                    manager.historyBackward()
                }
                .keyboardShortcut("[")
                .disabled(!manager.historyCanMoveBackward)
                
                Button("Forward") {
                    manager.historyForward()
                }
                .keyboardShortcut("]")
                .disabled(!manager.historyCanMoveForward)
                
                Button("Show All Preferences") {
                    manager.setPane(to: nil)
                }
                .keyboardShortcut("l")
                
                Button("Customize...") {
                    withAnimation(.linear(duration: 0.1)) {
                        manager.isEditing.toggle()
                    }
                }
                
                Divider()
                
                Picker(selection: $manager.shouldGroup) {
                    Text("Organize by Categories").tag(true)
                    Text("Organize Alphabetically").tag(false)
                } label: {}
                    .pickerStyle(.inline)

                // TODO: Enable
                Button("Search") {
                    search.field.window?.makeFirstResponder(search.field)
                }.keyboardShortcut("f")
                    .disabled(true)
                
                Divider()


                ForEach(manager.allPanes) { pane in
                    Button {
                        manager.setPane(to: pane.type)
                    } label: {
                        let name = PaneConstants.nameTable[pane.type.rawValue]
                        
                        HStack {
                            Image("\(name) Icon")
                            Text(name)
                        }
                    }
                }
            }
        }
    }
}
