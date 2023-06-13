//
//  PaneConstants.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import Foundation

struct PaneConstants {
    static let paneWidth: CGFloat = 668
    static let panePadding: CGFloat = 20
    
    // TODO: Revise this when all pausible panes are finished
    static let supportTable: [Bool] = [
        false, // desktop
        false, // dock
        false, // missionControl
        false, // siri
        false, // spotlight
        false, // language
        false, // notifications
        false, // users
        false, // accessibility
        false, // security
        false, // network
        false, // bluetooth
        false, // sound
        false, // printersAndScanners
        false, // keyboard
        false, // trackpad
        false, // mouse
        false, // displays
        false, // battery
        false, // dataAndTime
//        false, // sharing
        false, // energySaver
//        false, // sidecar
//        false, // wallet
//        false, // touchID
        false, // internetAccounts
        false, // startupDisk
        true, // screenTime
        true, // softwareUpdate
        true, // timeMachine
        true, // appleID
        true, // familySharing
        true // appearance
    ]
    
    static let nameTable: [String] = [
        "Desktop & Screensaver",
        "Dock & Menu Bar",
        "Mission Control",
        "Siri",
        "Spotlight",
        "Language & Region",
        "Notifications",
        "Users & Groups",
        "Accessibility",
        "Security & Privacy",
        "Network",
        "Bluetooth",
        "Sound",
        "Printers & Scanners",
        "Keyboard",
        "Trackpad",
        "Mouse",
        "Displays",
        "Battery",
        "Date & Time",
//        "Sharing",
        "Energy Saver",
//        "Sidecar",
//        "Wallet",
//        "TouchID",
        "Internet Accounts",
        "Startup Disk",
        "Screen Time",
        "Software Update",
        "Time Machine",
        "Apple ID",
        "Family Sharing",
        "General"
    ]
    
    static let priTable: [UInt32] = [
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        13,
        14,
        17,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        29,
        30,
//        31,
        28,
//        27,
//        11,
//        12,
        10,
        33,
        15,
        18,
        32,
        0,
        1,
        2,
    ]
    
    enum PaneType: Int, CaseIterable {
        case desktopAndScreensaver = 0
        case dockAndMenubar
        case missionControl
        case siri
        case spotlight
        case languageAndRegion
        case notification
        case users
        case accessibility
        case security
        case network
        case bluetooth
        case sound
        case printersAndScanners
        case keyboard
        case trackpad
        case mouse
        case displays
        case battery
        case dataAndTime
//        case sharing
        case energySaver
//        case sidecar
//        case wallet
//        case touchID
        case internetAccounts
        case startupDisk
        case screenTime
        case softwareUpdate
        case timeMachine
        case appleID
        case familySharing
        case appearance
    }
}
