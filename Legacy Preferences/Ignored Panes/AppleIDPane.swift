//
//  AppleIDPane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct AppleIDPane: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                VisualEffectView(material: .contentBackground, blendingMode: .withinWindow)
                
                VStack {
                    VStack {
                        Image("AccountBlank_big")
                            .resizable()
                            .interpolation(.high)
                            .frame(width: 100, height: 100)
                            .mask(Circle())
                        
                        Text("---")
                            .font(.body.bold())
                        
                        Text("---")
                            .font(.caption)
                            .padding(.bottom, 6)
                    }
                    .padding(PaneConstants.panePadding)
                    
                    VStack(spacing: 8) {
                        PaneSidebarItem(image: "Overview_Normal", name: "Overview")
                        PaneSidebarItem(image: "Contact_Normal", name: "Name, Phone, Email")
                        PaneSidebarItem(image: "Password_Normal", name: "Password & Security")
                        PaneSidebarItem(image: "Payment_Normal", name: "Payment & Shipping")
                        
                        Divider().padding([.top, .bottom], 6)
                    }
                    .disabled(true)
                    .padding(.horizontal, PaneConstants.panePadding - 8)
                    
                    
                    VStack(spacing: 8) {
                        PaneSidebarItem(image: "iCloud_Normal", name: "iCloud")
                        PaneSidebarItem(image: "Appstore_Normal", name: "Media & Purchases")
                        
                        Divider().padding([.top, .bottom], 6)
                    }
                    .disabled(true)
                    .padding(.horizontal, PaneConstants.panePadding - 8)
                    
                    ProgressView()
                        .scaleEffect(0.5)
                    
                    Spacer()
                }
            }
            .frame(width: 193)
            
            Divider()
            
            UnavailableLabel()
        }
        .frame(width: PaneConstants.paneWidth, height: 560)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.appleID.rawValue])
    }
}

struct AppleIDPane_Previews: PreviewProvider {
    static var previews: some View {
        AppleIDPane()
    }
}
