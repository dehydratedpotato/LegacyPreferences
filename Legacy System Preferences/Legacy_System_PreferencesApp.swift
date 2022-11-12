//
//  Legacy_System_PreferencesApp.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import SwiftUI

extension NSToolbarItem.Identifier {
    static let search = NSToolbarItem.Identifier(rawValue: "legacyPrefsSearch")
    static let home = NSToolbarItem.Identifier(rawValue: "legacyPrefsHome")
    static let backwards = NSToolbarItem.Identifier(rawValue: "legacyPrefsBackwards")
    static let forwards = NSToolbarItem.Identifier(rawValue: "legacyPrefsForwards")
}

class AppearanceSelectorButton {}

class AppDelegate: NSObject, NSApplicationDelegate {
    @ObservedObject var prefsList: PaneHandler = PaneHandler()
    
    var window:           NSWindow!
    var menu:             NSMenu!
    var prevRect:         NSRect!
    let toolbarItemArray: [NSToolbarItem.Identifier] = [.search, .home]
    
    var appname = "Legacy System Preferences"
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(contentRect: NSRectFromCGRect(CGRectMake(0, 0, 670, 0)),
                          styleMask: [.titled,
                                      .closable,
                                      .miniaturizable,
                                    ],
                          backing: .buffered,
                          defer: false)
        
        window.title   = appname
        window.toolbar = NSToolbar(identifier: "legacyPrefsToolbar")
        
        window.toolbar?.delegate = self
        window.toolbar?.insertItem(withItemIdentifier: .search, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .home, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .forwards, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .backwards, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .flexibleSpace, at: 0)
        window.toolbar?.displayMode = .iconOnly
        window.toolbar?.allowsUserCustomization = false
        
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        let homeview = NSHostingView(rootView: PreferenceHomeView(prefsList: prefsList))
        homeview.animator().alphaValue = 1
        window.contentView = homeview
        
        var rect = window.frame
        rect.origin.y -= rect.size.height
        rect.origin.y += homeview.frame.size.height
        rect.size = homeview.frame.size
        prevRect = rect

        window.setFrame(rect, display: true, animate: true)

        return
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        if prefsList.currentPane != "showall" {
            prefsList.manager.attempClosePreference()
        }
        
        return
    }
    
    func applicationWillFinishLaunching(_ notification:Notification) {
        populateMainMenu()
    }
    
    // programmatic main menus are really dumb for some reason
    // thank you, old posts: https://lapcatsoftware.com/articles/working-without-a-nib-part-10.html
    func populateMainMenu() {
        let mainMenu = NSMenu(title:"MainMenu")
         
        var menuItem = mainMenu.addItem(withTitle:"Application", action:nil, keyEquivalent:"")
        var submenu = NSMenu(title:"Application")
        populateApplicationMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        
        menuItem = mainMenu.addItem(withTitle:"File", action:nil, keyEquivalent:"")
        submenu = NSMenu(title:NSLocalizedString("File", comment:"File menu"))
        populateFileMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        
        menuItem = mainMenu.addItem(withTitle:"View", action:nil, keyEquivalent:"")
        submenu = NSMenu(title:NSLocalizedString("View", comment:"View menu"))
        populateViewMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        
        menuItem = mainMenu.addItem(withTitle:"Window", action:nil, keyEquivalent:"")
        submenu = NSMenu(title:NSLocalizedString("Window", comment:"Window menu"))
        populateWindowMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        NSApp.windowsMenu = submenu
        
        menuItem = mainMenu.addItem(withTitle:"Help", action:nil, keyEquivalent:"")
        submenu = NSMenu(title:NSLocalizedString("Help", comment:"View menu"))
        populateHelpMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        
        NSApp.mainMenu = mainMenu
    }
    
    func populateApplicationMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("About", comment:"About menu item") + " " + appname
        var menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent:"")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Services", comment:"Services menu item")
        menuItem = menu.addItem(withTitle:title, action:nil, keyEquivalent:"")
        let servicesMenu = NSMenu(title:"Services")
        menu.setSubmenu(servicesMenu, for:menuItem)
        NSApp.servicesMenu = servicesMenu
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Hide", comment:"Hide menu item") + " " + appname
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.hide(_:)), keyEquivalent:"h")
        menuItem.target = NSApp
        
        title = NSLocalizedString("Hide Others", comment:"Hide Others menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.hideOtherApplications(_:)), keyEquivalent:"h")
        menuItem.keyEquivalentModifierMask = [.command, .option]
        menuItem.target = NSApp
        
        title = NSLocalizedString("Show All", comment:"Show All menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.unhideAllApplications(_:)), keyEquivalent:"")
        menuItem.target = NSApp
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Quit", comment:"Quit menu item") + " " + appname
        menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.terminate(_:)), keyEquivalent:"q")
        menuItem.target = NSApp
    }
    
    func populateFileMenu(_ menu:NSMenu) {
        let title = NSLocalizedString("Close Window", comment:"Close Window menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performClose(_:)), keyEquivalent:"w")
    }
    
    func populateViewMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("Show Toolbar", comment:"Show Toolbar menu item")
        var menuItem = menu.addItem(withTitle:title, action:#selector(NSWindow.toggleToolbarShown(_:)), keyEquivalent:"t")
        menuItem.keyEquivalentModifierMask = [.command, .option]
        
        title = NSLocalizedString("Customize Toolbar...", comment:"Customize Toolbar... menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.runToolbarCustomizationPalette(_:)), keyEquivalent:"")
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Enter Full Screen", comment:"Enter Full Screen menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(NSWindow.toggleFullScreen(_:)), keyEquivalent:"f")
        menuItem.keyEquivalentModifierMask = [.command, .control]
    }
    
    func populateWindowMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("Minimize", comment:"Minimize menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performMiniaturize(_:)), keyEquivalent:"m")
        
        title = NSLocalizedString("Zoom", comment:"Zoom menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performZoom(_:)), keyEquivalent:"")
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Bring All to Front", comment:"Bring All to Front menu item")
        let menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.arrangeInFront(_:)), keyEquivalent:"")
        menuItem.target = NSApp
    }
    
    func populateHelpMenu(_ menu:NSMenu) {
        let title = appname + " " + NSLocalizedString("Help", comment:"Help menu item")
        let menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.showHelp(_:)), keyEquivalent:"?")
        menuItem.target = NSApp
    }
}


extension AppDelegate: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        let toolbarItem = NSToolbarItem(itemIdentifier: itemIdentifier)
        
        switch itemIdentifier {
        case .search:
            let search = NSSearchToolbarItem(itemIdentifier: .search)
            search.label = "Search"
            search.searchField.addConstraint(NSLayoutConstraint(item: search.searchField, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .width, multiplier: 1, constant: 165) )
            search.isEnabled = false
            return search
        case .home:
            if let img = NSImage(systemSymbolName: "square.grid.4x3.fill", accessibilityDescription: "") {
                toolbarItem.toolTip = "Show All"
                toolbarItem.isBordered = true
                toolbarItem.image = img
                toolbarItem.target = nil
                toolbarItem.action = #selector(showAll)
                toolbarItem.isNavigational = true
                break
            } else {
                NSLog("Error, couldn't find grid image for toolbar item")
            }
        case .backwards:
            if let img = NSImage(systemSymbolName: "chevron.left", accessibilityDescription: "") {
                toolbarItem.isBordered = true
                toolbarItem.image = img
                toolbarItem.target = nil
                toolbarItem.action = nil//#selector(backwards)
                toolbarItem.isNavigational = true
                break
            } else {
                NSLog("Error, couldn't find grid image for toolbar item")
            }
        case .forwards:
            if let img = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: "") {
                toolbarItem.isBordered = true
                toolbarItem.image = img
                toolbarItem.target = nil
                toolbarItem.action = nil//#selector(forwards)
                toolbarItem.isNavigational = true
                break
            } else {
                NSLog("Error, couldn't find grid image for toolbar item")
            }
        default:
            return toolbarItem
        }
        
        return toolbarItem
    }
    
    @objc func showAll() {
        if (prefsList.currentPane != "showall") {
            
            prefsList.currentPane = "showall"
            prefsList.backwardsHistory.append("showall")
            prefsList.manager.attempClosePreference()
            
            let homeview = NSHostingView(rootView: PreferenceHomeView(prefsList: prefsList))
            homeview.animator().alphaValue = 0
            
            window.contentView = homeview
            homeview.animator().alphaValue = 1
            
            var rect = window.frame
            rect.origin.y += rect.size.height
            rect.origin.y -= homeview.frame.size.height
            rect.size = prevRect.size
            
            window.setFrame(rect, display: true, animate: true)
        }
    }
    
    @objc func search() {
        
    }
    
    @objc func backwards() {
        print("Navigating backwards...")
        print(prefsList.backwardsHistory)
        print(prefsList.currentPane)
        
        if prefsList.backwardsHistory.count >= 2 {
            let idx = (prefsList.backwardsHistory.indices.last ?? 1) - 1
            
            if prefsList.backwardsHistory[idx] == "showall" {
                showAll()
                if prefsList.backwardsHistory.count == 2 {
                    prefsList.backwardsHistory = ["showall"]
                } else {
                    prefsList.backwardsHistory.remove(at: idx + 1)
                }
            } else {
                prefsList.manager.loadPreference(prefsList.backwardsHistory[idx])
                if prefsList.manager.applyViewFromPreference() {
                    prefsList.currentPane = prefsList.backwardsHistory[idx]
                }
                prefsList.forwardsHistory.append(prefsList.backwardsHistory[idx])
                prefsList.backwardsHistory.remove(at: idx)
            }
        } else if prefsList.backwardsHistory.count == 1 {
            showAll()
        }
    }
    
    @objc func forwards() {
        print("Navigating forwards...")
        print(prefsList.forwardsHistory)
        print(prefsList.currentPane)
        
        if prefsList.forwardsHistory.count > 0 {
            let idx = (prefsList.backwardsHistory.indices.last ?? 0)
            
            if prefsList.backwardsHistory[idx] == "showall" {
                showAll()
                prefsList.backwardsHistory = ["showall"]
            } else {
                prefsList.manager.loadPreference(prefsList.backwardsHistory[idx])
                if prefsList.manager.applyViewFromPreference() {
                    prefsList.currentPane = prefsList.backwardsHistory[idx]
                }
                prefsList.backwardsHistory.append(prefsList.backwardsHistory[idx])
                prefsList.forwardsHistory.remove(at: idx)
            }
        }
    }
    
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarItemArray
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarItemArray
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return []
    }
}

