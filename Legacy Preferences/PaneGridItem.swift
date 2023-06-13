//
//  GridItem.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct PaneGridItem: Identifiable, View {
    let id = UUID()
    let type: PaneConstants.PaneType
    
    @Binding var isEditing: Bool
    @State private var isVisible: Bool = true
    
    var body: some View {
        let name = PaneConstants.nameTable[type.rawValue]
        
        Button(action: {
            PaneManager.shared.setPane(to: type)
        }, label: {
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image("\(name) Icon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    
                    if isEditing && (type != .appleID && type != .familySharing) {
                        Toggle(isOn: .init(get: {
                            return isVisible
                        }, set: { newValue in
                            PaneManager.shared.setPane(type: type, toVisibility: newValue)

                            isVisible.toggle()
                        }), label: {
                            //
                        })
                        .toggleStyle(.checkbox)
                    }
                }
                .frame(width: 40, height: 40)
                
                Text(name)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(width: 76, height: 85)
        })
        .buttonStyle(.plain)
        .onAppear {
            isVisible = !PaneManager.shared.hiddenPanes.contains(type.rawValue)
        }
        .disabled(!PaneConstants.supportTable[type.rawValue])
    }
}

