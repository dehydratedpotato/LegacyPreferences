//
//  VisualEffectView.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        
        visualEffectView.material = self.material
        visualEffectView.blendingMode = self.blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = self.material
        visualEffectView.blendingMode = self.blendingMode
    }
}
