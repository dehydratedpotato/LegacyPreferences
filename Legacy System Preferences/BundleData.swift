//
//  BundleData.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import Foundation

enum AppleBundleIDs: String, CaseIterable {
    case Accounts = "com.apple.preferences.users"
    case Appearance = "com.apple.preference.general"
    case AppleID = "com.apple.preferences.AppleIDPrefPane"
    case Battery = "com.apple.preference.battery"
    case Bluetooth = "com.apple.preferences.Bluetooth"
    case DateAndTime = "com.apple.preference.datetime"
    case DesktopScreenEffects = "com.apple.preference.desktopscreeneffect"
    case DigiHubDiscs = "com.apple.preference.digihub.discs"
    case Displays = "com.apple.preference.displays"
    case Dock = "com.apple.preference.dock"
    case EnergySaver = "com.apple.preference.energysaver"
    case Expose = "com.apple.preference.expose"
    case Extensions = "com.apple.preferences.extensions"
    case FamilySharing = "com.apple.preferences.FamilySharingPrefPane"
    case FibreChannel = "com.apple.prefpanel.fibrechannel"
    case InternetAccounts = "com.apple.preferences.internetaccounts"
    case Keyboard = "com.apple.preference.keyboard"
    case Localization = "com.apple.Localization"
    case Mouse = "com.apple.preference.mouse"
    case Network = "com.apple.preference.network"
    case Notifications = "com.apple.preference.notifications"
    case PrintAndScan = "com.apple.preference.printfax"
    case ScreenTime = "com.apple.preference.screentime"
    case Security = "com.apple.preference.security"
    case SharingPref = "com.apple.preferences.sharing"
    case Sidecar = "com.apple.preference.sidecar"
    case SoftwareUpdate = "com.apple.preferences.softwareupdate"
    case Sound = "com.apple.preference.sound"
    case Siri = "com.apple.preference.speech"
    case Spotlight = "com.apple.preference.spotlight"
    case StartupDisk = "com.apple.preference.startupdisk"
    case TimeMachine = "com.apple.prefs.backup"
    case TouchID = "com.apple.preferences.password"
    case Trackpad = "com.apple.preference.trackpad"
    case UniversalAccess = "com.apple.preference.universalaccess"
    case Wallet = "com.apple.preferences.wallet"
    
    case Profiles = "com.apple.preferences.configurationprofiles"
    case Classroom = "com.apple.ClassroomSettings"
    case ClassKit = "com.apple.preferences.ClassKitPreferencePane"
}

let bundlePriority: [AppleBundleIDs:Int32] = [
    .Accounts : 13,
    .Appearance : 2,
    .AppleID : 0,
    .Battery : 29,
    .Bluetooth : 20,
    .DateAndTime : 30,
    .DesktopScreenEffects : 3,
    .DigiHubDiscs : 34,
    .Displays : 26,
    .Dock : 4,
    .EnergySaver : 28,
    .Expose : 5,
    .Extensions : 16,
    .FamilySharing : 1,
    .FibreChannel : 35,
    .InternetAccounts : 10,
    .Keyboard : 23,
    .Localization : 8,
    .Mouse : 25,
    .Network : 19,
    .Notifications : 9,
    .PrintAndScan : 22,
    .ScreenTime : 15,
    .Security : 17,
    .SharingPref : 31,
    .Sidecar : 27,
    .SoftwareUpdate : 18,
    .Sound : 21,
    .Siri : 6,
    .Spotlight : 7,
    .StartupDisk : 33,
    .TimeMachine : 32,
    .TouchID : 12,
    .Trackpad : 24,
    .UniversalAccess : 14,
    .Wallet : 11,
    
    .Profiles : 100,
    .Classroom : 101,
    .ClassKit : 102
]
