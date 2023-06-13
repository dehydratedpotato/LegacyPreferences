//
//  PaneDefaults.swift
//  AppearancePane
//
//  Created by dehydratedpotato on 6/1/23.
//

import SwiftUI

final class PaneDefaults: ObservableObject {
    static let bundle: Bundle = .init(identifier: "com.dehydratedpotato.Legacy-Preferences.AppearancePane")!
    static let paneHeight: CGFloat = 620
    static let maximumPickerWidth: CGFloat = 170
    static let labelColumnWidth: CGFloat = 230
    
    static let accentTypeNameTable: [String] = [
        "Red",
        "Orange",
        "Yellow",
        "Green",
        "Blue",
        "Purple",
        "Pink",
        "Graphite",
        "Multicolor"
    ]
    
    static let highlightTypeNameTable: [String] = [
        "Red",
        "Orange",
        "Yellow",
        "Green",
        "Blue",
        "Purple",
        "Pink",
        "Graphite",
        "Accent Color"
    ]
    
    // MARK: - Types
    
    enum ThemeType: String {
        case light = "Light"
        case dark = "Dark"
        case auto = "Auto"
    }
    
    enum AccentType: Int {
        case red = 0
        case orange = 1
        case yellow = 2
        case green = 3
        case blue = 4
        case purple = 5
        case pink = 6
        case gray = 7
        case multicolor = 8
    }
    
    enum HighlightType: Int {
        case red = 0
        case orange = 1
        case yellow = 2
        case green = 3
        case blue = 4
        case purple = 5
        case pink = 6
        case gray = 7
        case accentcolor = 8
    }
    
    struct Accent: Identifiable {
        let id: AccentType
        let color: Color
    }
    
    struct Theme: Identifiable {
        let id: ThemeType
        let hint: String
    }
    
    enum ShowScrollbarType: String {
        case whenScrolling = "WhenScrolling"
        case auto = "Automatic"
        case always = "Always"
    }
    
    enum TabbingModeType: String {
        case fullscreen = "fullscreen"
        case always = "always"
        case never = "never"
    }
    
    
    // MARK: - Theme logic
    
    var themeIsDark: Bool {
        return SLSGetAppearanceThemeLegacy() == .dark
    }

    var themeIsAuto: Bool {
        return SLSGetAppearanceThemeSwitchesAutomatically() == 1
    }
    
    lazy var startTheme: ThemeType = {
        if self.themeIsDark {
            return .dark
        }
        if self.themeIsAuto {
           return .auto
        }
        return .light
    }()
    
    func setInterfaceStyle(isDark: Bool, isAuto: Bool) {
        if isDark {
            SLSSetAppearanceThemeLegacy(.dark)
        } else {
            SLSSetAppearanceThemeLegacy(.light)
        }
        
        if isAuto {
            SLSSetAppearanceThemeSwitchesAutomatically(1)
        } else {
            SLSSetAppearanceThemeSwitchesAutomatically(0)
        }
        
        Logger.log("isDark: \(self.themeIsDark), isAuto: \(self.themeIsAuto)", class: Self.self)
    }
    
    // MARK: - Accent color logic
    
    lazy var startAccentColor: AccentType = {
        let color = NSColorGetUserAccentColor()
        
        switch color {
        case -1:
            return .gray
        case -2:
            return .multicolor
        default:
            return AccentType(rawValue: Int(color)) ?? .multicolor
        }
    }()
    
    func setAccentColor(toType type: PaneDefaults.AccentType) {
        self.setHighlightColor(toType: PaneDefaults.HighlightType(rawValue: type.rawValue)! )
        
        switch type {
        case .multicolor:
            NSColorSetUserAccentColor(-2)
        case .gray:
            NSColorSetUserAccentColor(-1)
        default:
            NSColorSetUserAccentColor(Int32( type.rawValue))
        }
        
        Logger.log("accentColor: \(type)", class: Self.self)
    }
    
    // MARK: - Highlight color logic
    
    lazy var startHighlightColor: HighlightType = {
        let color = NSColorGetUserHighlightColor()
        
        switch color {
        case -2:
            return .gray
        case -1:
            return .accentcolor
        default:
            return HighlightType(rawValue: Int(color)) ?? .accentcolor
        }
    }()
    
    func setHighlightColor(toType type: PaneDefaults.HighlightType) {
        switch type {
        case .accentcolor:
            NSColorSetUserAccentColor(-1)
        case .gray:
            NSColorSetUserAccentColor(-2)
        default:
            NSColorSetUserHighlightColor(Int32( type.rawValue))
        }
        
        Logger.log("highlightColor: \(type)", class: Self.self)
    }
    
    // MARK: - Sidebar size logic
    
    static let sidebarSizeKey = "NSTableViewDefaultSizeMode"
    static let sidebarSizeNotifKey = "AppleSideBarDefaultIconSizeChanged"
    
    lazy var startSidebarSize: Int = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get sidebar size", isError: true, class: Self.self)
            return 2 // medium = 2
        }

        return domain[PaneDefaults.sidebarSizeKey] as! Int
    }()
     
    func setSidebarSize(toSize size: Int) -> Bool {
        guard var domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain),
              domain.contains(where: { $0.key == PaneDefaults.sidebarSizeKey })
        else {
            Logger.log("failed to set sidebar size", isError: true, class: Self.self)
            return false
        }

        domain[PaneDefaults.sidebarSizeKey] = size
        
        UserDefaults.standard.setPersistentDomain(domain, forName:  UserDefaults.globalDomain)
        
        DistributedNotificationCenter.default().post(name: .init(PaneDefaults.sidebarSizeNotifKey), object: nil)
        
        Logger.log("sidebarSize: \(size)", class: Self.self)
        
        return true
    }
    
    // MARK: - Wallpaper tinting logic
    
    static let wallpaperTintingKey = "AppleReduceDesktopTinting"
    static let wallpaperTintingNotifKey = "AppleReduceDesktopTintingChanged"
    
    lazy var startWallpaperTinting: Bool = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get tint value", isError: true, class: Self.self)
            return true
        }

        return !(domain[PaneDefaults.wallpaperTintingKey] as! Bool)
    }()
    
    func setWallpaperTint(to value: Bool)-> Bool {
        guard var domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain),
              domain.contains(where: { $0.key == PaneDefaults.wallpaperTintingKey })
        else {
            Logger.log("failed to set tint value", isError: true, class: Self.self)
            return false
        }

        domain[PaneDefaults.wallpaperTintingKey] = value
        
        UserDefaults.standard.setPersistentDomain(domain, forName:  UserDefaults.globalDomain)
        
        DistributedNotificationCenter.default().post(name: .init(PaneDefaults.wallpaperTintingNotifKey), object: nil)
        
        Logger.log("reduceTinting: \(value)", class: Self.self)
        
        return true
    }
    
    // MARK: - Show scrollbar logic
    
    static let showScrollbarKey = "AppleShowScrollBars"
    static let showScrollbarNotifKey = "AppleShowScrollBarsSettingChanged"
    
    lazy var startShowScrollbars: ShowScrollbarType = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get scrollbar show type", isError: true, class: Self.self)
            return .auto
        }

        return .init(rawValue: domain[PaneDefaults.showScrollbarKey] as! String ) ?? .auto
    }()
    
    func setShowScrollbars(to value: ShowScrollbarType) -> Bool {
        guard var domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain),
              domain.contains(where: { $0.key == PaneDefaults.showScrollbarKey })
        else {
            Logger.log("failed to set scrollbar show type", isError: true, class: Self.self)
            return false
        }

        domain[PaneDefaults.showScrollbarKey] = value.rawValue
        
        UserDefaults.standard.setPersistentDomain(domain, forName:  UserDefaults.globalDomain)
        
        DistributedNotificationCenter.default().post(name: .init(PaneDefaults.showScrollbarNotifKey), object: nil)
        
        Logger.log("showScrollbar: \(value)", class: Self.self)
        
        return true
    }
    
    // MARK: - Jump to page logic
    // MARK: - Close windows when quit and Confirm close quitting logic
    
    static let windowQuitKey = "NSQuitAlwaysKeepsWindows"
    static let closeAlwaysConfirms = "NSCloseAlwaysConfirmsChanges"
    static let jumpPageKey = "AppleScrollerPagingBehavior"
    
    lazy var startJumpPage: Bool = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get jump page value", isError: true, class: Self.self)
            return false
        }

        return domain[PaneDefaults.jumpPageKey] as! Bool
    }()
    
    lazy var startWindowQuit: Bool = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get window quitting value", isError: true, class: Self.self)
            return false
        }

        return domain[PaneDefaults.windowQuitKey] as! Bool
    }()
    
    lazy var startcloseAlwaysConfirms: Bool = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get close always confirm value", isError: true, class: Self.self)
            return false
        }

        return domain[PaneDefaults.closeAlwaysConfirms] as! Bool
    }()
    
    func setBool(for key: String, to value: Bool) -> Bool {
        guard var domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain),
              domain.contains(where: { $0.key == key })
        else {
            Logger.log("failed to value for \(key)", isError: true, class: Self.self)
            return false
        }

        domain[key] = value
        
        UserDefaults.standard.setPersistentDomain(domain, forName:  UserDefaults.globalDomain)
        
        Logger.log("\(key): \(value)", class: Self.self)
        
        return true
    }

    // MARK: - Tabbing mode logic
    
    static let tabbingModeKey = "AppleWindowTabbingMode"
    
    lazy var startTabbingMode: TabbingModeType = {
        guard let domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain) else {
            Logger.log("failed to get tabbing mode type", isError: true, class: Self.self)
            return .fullscreen
        }

        return .init(rawValue: domain[PaneDefaults.tabbingModeKey] as! String ) ?? .fullscreen
    }()
    
    func setTabbingMode(to value: TabbingModeType) -> Bool {
        guard var domain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain),
              domain.contains(where: { $0.key == PaneDefaults.tabbingModeKey })
        else {
            Logger.log("failed to set tabbing mode type", isError: true, class: Self.self)
            return false
        }

        domain[PaneDefaults.tabbingModeKey] = value.rawValue
        
        UserDefaults.standard.setPersistentDomain(domain, forName:  UserDefaults.globalDomain)
        
        Logger.log("tabbingMode: \(value)", class: Self.self)
        
        return true
    }
}
