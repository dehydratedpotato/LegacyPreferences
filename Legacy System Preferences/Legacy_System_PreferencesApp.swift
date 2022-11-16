//
//  Legacy_System_PreferencesApp.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import SwiftUI

let appname = "Legacy System Preferences"

extension NSToolbarItem.Identifier {
    static let search = NSToolbarItem.Identifier(rawValue: "legacyPrefsSearch")
    static let home = NSToolbarItem.Identifier(rawValue: "legacyPrefsHome")
    static let done = NSToolbarItem.Identifier(rawValue: "legacyPrefsDone")
    static let backwards = NSToolbarItem.Identifier(rawValue: "legacyPrefsBackwards")
    static let forwards = NSToolbarItem.Identifier(rawValue: "legacyPrefsForwards")
}

class AppDelegate: NSObject, NSApplicationDelegate {
    @ObservedObject var prefsList: PaneHandler = PaneHandler()
    
    var window:           NSWindow!
    var menu:             NSMenu!
    var prevRect:         NSRect!
    var organizeGrouped:       NSMenuItem!
    var organizeAlphabetical:  NSMenuItem!
    var customizePanes:        NSMenuItem!
//    var viewctl:          NSViewController!
    let toolbarItemArray: [NSToolbarItem.Identifier] = [.search, .home]
    
    func applicationDidFinishLaunching(_ notification: Notification)
    {
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 670, height: 0),
                          styleMask:   [.titled, .closable, .miniaturizable],
                          backing:     .buffered,
                          defer:       false)
        window.title                            = appname
        window.toolbar                          = NSToolbar(identifier: "legacyPrefsToolbar")
        window.isReleasedWhenClosed             = false
        window.toolbar?.delegate                = self
        window.toolbar?.allowsUserCustomization = false
        window.toolbar?.displayMode             = .iconOnly
        window.toolbar?.insertItem(withItemIdentifier: .search, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .home, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .forwards, at: 0)
        window.toolbar?.insertItem(withItemIdentifier: .backwards, at: 0)
        window.center()
        window.makeKeyAndOrderFront(nil)
        
        let homeview = NSHostingView(rootView: PreferenceHomeView(prefsList: prefsList))
        window.contentView = homeview
        
        var rect = window.frame
        rect.origin.y -= rect.size.height
        rect.origin.y += homeview.frame.size.height
        rect.size      = homeview.frame.size
        prevRect = rect

        window.setFrame(rect, display: true, animate: true)

        return
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window.center()
        window.makeKeyAndOrderFront(nil)
        return true
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
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    // programmatic main menus are really dumb for some reason
    // thank you, old posts: https://lapcatsoftware.com/articles/working-without-a-nib-part-10.html
    func populateMainMenu() {
        let mainMenu = NSMenu(title:"MainMenu")
         
        var menuItem = mainMenu.addItem(withTitle:"Application", action:nil, keyEquivalent:"")
        var submenu = NSMenu(title:"Application")
        populateApplicationMenu(submenu)
        mainMenu.setSubmenu(submenu, for:menuItem)
        
        menuItem = mainMenu.addItem(withTitle:"Edit", action:nil, keyEquivalent:"")
        submenu = NSMenu(title:NSLocalizedString("Edit", comment:"Edit menu"))
        populateEditMenu(submenu)
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
    
    
    func populateEditMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("Undo", comment:"Undo menu item")
        menu.addItem(withTitle:title, action:nil, keyEquivalent:"z")
        
        title = NSLocalizedString("Redo", comment:"Redo menu item")
        menu.addItem(withTitle:title, action:nil, keyEquivalent:"Z")
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Cut", comment:"Cut menu item")
        menu.addItem(withTitle:title, action:#selector(NSText.cut(_:)), keyEquivalent:"x")
        
        title = NSLocalizedString("Copy", comment:"Copy menu item")
        menu.addItem(withTitle:title, action:#selector(NSText.copy(_:)), keyEquivalent:"c")
        
        title = NSLocalizedString("Paste", comment:"Paste menu item")
        menu.addItem(withTitle:title, action:#selector(NSText.paste(_:)), keyEquivalent:"v")
        
        title = NSLocalizedString("Clear", comment:"Clear menu item")
        menu.addItem(withTitle:title, action:#selector(NSText.delete(_:)), keyEquivalent:"")
        
        title = NSLocalizedString("Select All", comment:"Select All menu item")
        menu.addItem(withTitle:title, action:#selector(NSText.selectAll(_:)), keyEquivalent:"a")
        
        menu.addItem(NSMenuItem.separator())
    }
    
    func populateViewMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("Back", comment:"Back menu item")
        var menuItem = menu.addItem(withTitle:title, action:nil/*#selector(backwards)*/, keyEquivalent:"[")
        menuItem.keyEquivalentModifierMask = [.command]
        
        title = NSLocalizedString("Forward", comment:"Forward menu item")
        menuItem = menu.addItem(withTitle:title, action:nil/*#selector(forwards)*/, keyEquivalent:"]")
        menuItem.keyEquivalentModifierMask = [.command]
        
        title = NSLocalizedString("Show All Preferences", comment:"All Preferences menu item")
        menuItem = menu.addItem(withTitle:title, action:#selector(showAll), keyEquivalent:"l")
        menuItem.keyEquivalentModifierMask = [.command]
        
        title = NSLocalizedString("Customize...", comment:"Customize menu item")
        customizePanes = menu.addItem(withTitle:title, action:#selector(allowCustomize), keyEquivalent:"")
        customizePanes.state = .off
        
        menu.addItem(NSMenuItem.separator())
        
        title = NSLocalizedString("Organize by Categories", comment:"Organize by Categories menu item")
        organizeGrouped = menu.addItem(withTitle:title, action:#selector(sortCategories), keyEquivalent:"")
        organizeGrouped.state = UserDefaults.standard.object(forKey: "Group") != nil ? UserDefaults.standard.bool(forKey: "Group") ? .on : .off : .on
        
        title = NSLocalizedString("Organize Alphabetically", comment:"Organize Alphabetically menu item")
        organizeAlphabetical = menu.addItem(withTitle:title, action:#selector(sortAlphabetical), keyEquivalent:"")
        organizeAlphabetical.state = UserDefaults.standard.object(forKey: "Group") != nil ? UserDefaults.standard.bool(forKey: "Group") ? .off : .on : .off
        
        title = NSLocalizedString("Search", comment:"Search menu item")
        menuItem = menu.addItem(withTitle:title, action:nil/*#selector(focusSearcher)*/, keyEquivalent:"f")
        menuItem.keyEquivalentModifierMask = [.command]
        
        menu.addItem(NSMenuItem.separator())
    }
    
    func populateWindowMenu(_ menu:NSMenu) {
        var title = NSLocalizedString("Close", comment:"Close Window menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performClose(_:)), keyEquivalent:"w")
        
        title = NSLocalizedString("Minimize", comment:"Minimize menu item")
        menu.addItem(withTitle:title, action:#selector(NSWindow.performMiniaturize(_:)), keyEquivalent:"m")
        
        menu.addItem(NSMenuItem.separator())
    }
    
    func populateHelpMenu(_ menu:NSMenu) {
        let title = appname + " " + NSLocalizedString("Help", comment:"Help menu item")
        let menuItem = menu.addItem(withTitle:title, action:#selector(NSApplication.showHelp(_:)), keyEquivalent:"?")
        menuItem.target = NSApp
    }
    
    @objc func allowCustomize() {
        withAnimation(.linear(duration: 0.1)) {
            if !prefsList.editing {
                prefsList.editing = true
                customizePanes.state = .on
                window.toolbar?.insertItem(withItemIdentifier: .done, at: 2)
                window.toolbar?.removeItem(at: 3)
            } else {
                prefsList.editing = false
                customizePanes.state = .off
                window.toolbar?.insertItem(withItemIdentifier: .home, at: 2)
                window.toolbar?.removeItem(at: 3)
            }
        }
    }
    @objc func sortCategories() {
        prefsList.group = true
        prefsList.update(excluding: prefsList.exclusion)
        organizeAlphabetical.state = .off
        organizeGrouped.state = .on
        
        UserDefaults.standard.set(true, forKey: "Group")
    }
    @objc func sortAlphabetical() {
        prefsList.group = false
        prefsList.update(excluding: prefsList.exclusion)
        organizeAlphabetical.state = .on
        organizeGrouped.state = .off
        
        UserDefaults.standard.set(true, forKey: "False")
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
        case .done:
            toolbarItem.isBordered = true
            toolbarItem.title = "Done"
            toolbarItem.target = nil
            toolbarItem.action = #selector(allowCustomize)
            toolbarItem.isNavigational = true
            break
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
            window.title = appname
            
            prefsList.currentPane = "showall"
            prefsList.backwardsHistory.append("showall")
            prefsList.manager.attempClosePreference()
            
            let homeview = NSHostingView(rootView: PreferenceHomeView(prefsList: prefsList))
            window.contentView = homeview

            var rect = window.frame
            rect.origin.y += rect.size.height
            rect.origin.y -= homeview.frame.size.height
            rect.size = prevRect.size
            
            window.setFrame(rect, display: true, animate: true)
        }
    }
    
    @objc func focusSearcher() {
        
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

