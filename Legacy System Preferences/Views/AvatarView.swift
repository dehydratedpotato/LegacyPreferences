//
//  AvatarView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

struct AvatarView: View {
    @Binding var visible: Bool
    @Binding var pane: Int
    
    @StateObject var manager: AvatarManager
    let opts = ["Current", "Defaults"]
    
    // this is a bit of a mess
    var body: some View {
        VStack(spacing:0) {
            HStack(spacing:0) {
                List(0..<2, selection: $pane) { i in
                    Text(opts[i])
                        .offset(x: 10, y:0)
                }
                .listStyle(.sidebar)
                
                
                if pane == 0 {
                    ZStack {
                        manager.avatar
                            .resizable()
                            .overlay(
                                ZStack {
                                    Color.black.opacity(0.5)
                                    Circle()
                                        .blendMode(.destinationOut)
                                }.compositingGroup()
                            )
                    }
                    .frame(width: 296)
                } else if pane == 1 {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),
                                            GridItem(.fixed(64)),]) {
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
            }
            HStack(spacing:10) {
                
                // this will stay here unless we can have access to Apple ID someday
                Text("Warning: Due to limitations regarding Apple ID access, this setting reflects the current user and is temporarily disabled.")
                    .font(.caption2)
                    .opacity(0.2)
                    .padding(.leading, 10)
                
                Spacer()
                
                Button("Cancel") { visible.toggle() }
                Button("Save") {
                    if pane == 0 {
                        
                    } else if pane == 1 {
                        for img in manager.defaults {
                            if img.id == manager.selected {
                                var s = img.path
                                if let dotRange = s.range(of: ".") {
                                    s.removeSubrange(dotRange.lowerBound..<s.indices.endIndex)
                                    s.append("*")
                                    manager.setAvatar(path: s)
                                }
                                break
                            }
                        }
                    }
                    visible.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(/*pane == 0*/ true)
            }
            .padding([.top, .bottom], 10)
            .padding(.trailing, 20)
            .background(VisualEffectView(material: .windowBackground, blendingMode: .withinWindow))
        }
        .frame(width: 475, height: 340)
    }
}


struct UserAvatar: View {
    @State var img: Image
    @State var user: String
    @State private var showTooltip = false
    @Binding var avatarSheet: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            img
                .resizable()
                .frame(width: 65, height: 65)
                .background(Color.white)
                .foregroundColor(.gray)
                .overlay(
                    VStack {
                        Spacer()
                        ZStack {
                            if showTooltip {
                                LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                                    .frame(height: 24)
                                    .opacity(0.6)
                                Text("edit")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                )
                .onHover {
                    showTooltip = $0
                }
                .mask(
                    Circle()
                        .onHover {
                            showTooltip = $0
                        }
                )
                .padding([.top, .bottom, .leading])
                .padding(.trailing, 4)
                .onTapGesture {
                    avatarSheet.toggle()
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user)
                    .font(.title2)
                Text("Apple ID, iCloud, Media & App Store")
                    .font(.callout)
            }
            .padding(.top, 25)
        }
    }
}
