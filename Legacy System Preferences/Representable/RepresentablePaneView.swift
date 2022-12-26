//
//  RepresentablePaneView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

struct PaneView: NSViewRepresentable {
    let pane: NSView
    
    func makeNSView(context: Context) -> some NSView {
        return pane
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.frame.size = pane.frame.size
    }
}
