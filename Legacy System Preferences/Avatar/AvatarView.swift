//
//  AvatarView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

public struct AvatarView: View {
    @EnvironmentObject public var manager: AvatarManager
    
    @Binding public var visible: Bool
    @Binding public var pane: AvatarManager.Pane
    
    private let columns: [GridItem] = [GridItem(.fixed(64)), GridItem(.fixed(64)), GridItem(.fixed(64)), GridItem(.fixed(64))]
    
    // this is a bit of a mess
    public var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                List(AvatarManager.Pane.allCases, id: \.rawValue, selection: $pane) { c in
                    Text(c.rawValue)
                        .offset(x: 10, y:0)
                        .tag(c)
                }
                .listStyle(.sidebar)
                
                switch pane {
                case .current:
                    currentView
                case .defaults:
                    defaultsView
                }
            }
            
            buttonsView
        }
        .frame(width: 475, height: 340)
    }
    
    @ViewBuilder private var defaultsView: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(manager.defaults) { img in
                    Image(nsImage: img.image)
                        .resizable()
                        .frame(width:64, height:64)
                        .border(Color.accentColor, width: manager.selected == img.id ? 2 : 0)
                        .onTapGesture {
                            manager.selected = img.id
                        }
                }
            }
            .padding(10)
        }
        .frame(width: 296)
    }
    
    @ViewBuilder private var currentView: some View {
        ZStack {
            manager.avatar
                .resizable()
                .overlay(
                    ZStack {
                        Color.black.opacity(0.5)
                        Circle().blendMode(.destinationOut)
                    }
                    .compositingGroup()
                )
        }
        .frame(width: 296)
    }
    
    @ViewBuilder private var buttonsView: some View {
        HStack(spacing:10) {
            
            // this will stay here unless we can have access to Apple ID someday
            Text("Warning: Due to limitations regarding Apple ID access, this setting reflects the current user and is temporarily disabled.")
                .font(.caption2)
                .opacity(0.2)
                .padding(.leading, 10)
            
            Spacer()
            
            Button("Cancel") { visible.toggle() }
            Button("Save") {
//                if pane == .defaults {
//                    for img in manager.defaults {
//                        if img.id == manager.selected {
//                            var s = img.path
//                            if let dotRange = s.range(of: ".") {
//                                s.removeSubrange(dotRange.lowerBound..<s.indices.endIndex)
//                                s.append("*")
//                                manager.setAvatar(path: s)
//                            }
//                            break
//                        }
//                    }
//                }
//                visible.toggle()
            }
            .buttonStyle(.borderedProminent)
            .disabled(/*pane == .current*/ true)
        }
        .padding([.top, .bottom], 10)
        .padding(.trailing, 20)
        .background(VisualEffectView(material: .windowBackground, blendingMode: .withinWindow))
    }
}
