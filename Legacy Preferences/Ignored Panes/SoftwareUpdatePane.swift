//
//  SoftwareUpdatePane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import SwiftUI

struct SoftwareUpdatePane: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                VisualEffectView(material: .contentBackground, blendingMode: .withinWindow)
                
                VStack() {
                    VStack() {
                        Image("SoftwareUpdate")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .mask(Circle())
                        
                        Text("Software Update")
                            .font(.body.bold())
                    }
                    .padding(PaneConstants.panePadding)
                    
                    Spacer()
                }
            }
            .frame(width: 193)
            
            Divider()
            
            UnavailableLabel()
        }
        .frame(width: PaneConstants.paneWidth, height: 236)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.softwareUpdate.rawValue])
    }
}

struct SoftwareUpdatePane_Previews: PreviewProvider {
    static var previews: some View {
        SoftwareUpdatePane()
    }
}
