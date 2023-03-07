//
//  PaneView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

public struct PaneView: NSViewRepresentable {
    public let pane: NSView
    
    public func makeNSView(context: Context) -> some NSView {
        return self.pane
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.frame.size = self.pane.frame.size
    }
}
