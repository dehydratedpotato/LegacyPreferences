//
//  ScreenTimePane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import SwiftUI

struct ScreenTimePane: View {
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

                    }
                    .padding(PaneConstants.panePadding)
                    
                    VStack(spacing: 8) {
                        PaneSidebarItem(image: "App Usage Icon_Normal", name: "App Usage")
                        PaneSidebarItem(image: "Notifications Icon_Normal", name: "Notifications")
                        PaneSidebarItem(image: "Pick Up Icon_Normal", name: "Pickups")
                        
                        Divider().padding([.top, .bottom], 6)
                    }
                    .disabled(true)
                    .padding(.horizontal, PaneConstants.panePadding - 8)
                    
                    
                    VStack(spacing: 8) {
                        PaneSidebarItem(image: "Down Time Icon_Normal", name: "Downtime")
                        PaneSidebarItem(image: "App Limits Icon_Normal", name: "App Limits")
                        PaneSidebarItem(image: "Commincation Limits Icon_Normal", name: "Communication")
                        PaneSidebarItem(image: "Always Allowed Icon_Normal", name: "Always Allowed")
                        PaneSidebarItem(image: "Content Privacy Icon_Normal", name: "Content & Privacy")
                        
                        
                        Divider().padding([.top, .bottom], 6)
                    }
                    .disabled(true)
                    .padding(.horizontal, PaneConstants.panePadding - 8)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        PaneSidebarItem(image: "Options Icon_Normal", name: "Options")
                    }
                    .disabled(true)
                    .padding(.horizontal, PaneConstants.panePadding - 8)
                    .padding(.bottom, PaneConstants.panePadding)
                }
            }
            .frame(width: 177)
            
            Divider()
            
            UnavailableLabel()
        }
        .frame(width: PaneConstants.paneWidth, height: 576)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.screenTime.rawValue])
    }
}

struct ScreenTimePane_Previews: PreviewProvider {
    static var previews: some View {
        ScreenTimePane()
    }
}
