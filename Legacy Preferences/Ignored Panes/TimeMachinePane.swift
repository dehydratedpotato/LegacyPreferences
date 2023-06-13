//
//  TimeMachinePane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct TimeMachinePane: View {
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                VisualEffectView(material: .contentBackground, blendingMode: .withinWindow)
                
                VStack(spacing: 14) {
                    VStack(spacing: 12) {
                        Image("TimeMachine_Normal")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .mask(Circle())
                        
                        Text("Time Machine")
                            .font(.body.bold())
                    }
                    .padding([.top, .leading, .trailing], PaneConstants.panePadding)
                    
                    Toggle("Back Up Automatically", isOn: .constant(false))
                        .disabled(true)
                    
                    Spacer()
                }
            }
            .frame(width: 193)
            
            Divider()
            
            UnavailableLabel()
        }
        .frame(width: PaneConstants.paneWidth, height: 405)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.timeMachine.rawValue])
    }
}

struct TimeMachinePane_Previews: PreviewProvider {
    static var previews: some View {
        TimeMachinePane()
    }
}
