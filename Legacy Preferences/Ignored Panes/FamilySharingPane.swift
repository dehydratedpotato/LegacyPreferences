//
//  FamilySharingPane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct FamilySharingPane: View {
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
                        PaneSidebarItem(image: "FamilySharing-sidebarIcon", name: "Family Sharing")
                        
                        
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
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.familySharing.rawValue])
    }
}

struct FamilySharingPane_Previews: PreviewProvider {
    static var previews: some View {
        FamilySharingPane()
    }
}
