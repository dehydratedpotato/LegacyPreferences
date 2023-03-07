//
//  VisualEffectView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

public struct VisualEffectView: NSViewRepresentable {
    public let material:     NSVisualEffectView.Material
    public let blendingMode: NSVisualEffectView.BlendingMode
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        
        visualEffectView.material     = self.material
        visualEffectView.blendingMode = self.blendingMode
        visualEffectView.state        = NSVisualEffectView.State.active
        
        return visualEffectView
    }

    public func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material     = self.material
        visualEffectView.blendingMode = self.blendingMode
    }
}
