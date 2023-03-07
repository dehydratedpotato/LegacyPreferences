//
//  PaneItem.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 3/6/23.
//

import SwiftUI

public struct PaneItem: Identifiable {
    public let id: String
    
    public var name: String
    public let appIcon: Image?
    public let path: String
    public let priority: UInt8

    public var visible: Bool = true
    public var customizable: Bool = true
    public var keywords: NSDictionary = NSDictionary()
    
    public var section: PaneItem.Section
    
    public enum Section: Int {
        case primary   = 0
        case secondary = 1
        case tertiary  = 3
        case none      = -1
    }
}
