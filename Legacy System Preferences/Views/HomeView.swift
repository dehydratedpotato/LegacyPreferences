//
//  HomeView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject var manager: PaneManager
    @State       var avatarSheet = false
    @State       var avatarPane  = 0
    
    @ObservedObject var avatarManager = AvatarManager()
    
    var body: some View {
//        ZStack {
            if manager.currentView == nil {
                ZStack {
                    VStack(spacing:0) {
                        ZStack {
                            HStack {
                                UserAvatar(img: avatarManager.avatar, user: NSFullUserName(), avatarSheet: $avatarSheet)
                                
                                Spacer()
                                HStack {
                                    ForEach(manager.header) { pane in
                                        PaneItemView(item: pane, hidden: $manager.hidden,
                                                     editing: $manager.editing,
                                                     search: $manager.query,
                                                     results: .constant([]))
                                        .onTapGesture {
                                            print("\(manager.openPane(pane: pane) ? "Successfully opened" : "Failed to open") pane \"\(pane.name)\" (\(pane.path) ")
                                            manager.accesslayer.loadPreference(pane.path)
                                        }
                                    }
                                    .padding([.trailing, .leading], 2)
                                }
                                .padding(.top, 8)
                            }
                            .padding(6)
                            
                            if manager.query != "" {
                                ZStack {
                                    Color.black
                                    HStack {
                                        Spacer()
                                        ForEach(manager.header) { pane in
                                            manager.returnSpotlightFocus(query: manager.query, pane: pane)
                                                .scaleEffect(2)
                                                .padding(.bottom, 10)
                                            
                                                .blendMode(.destinationOut)
                                        }
                                        .padding([.trailing, .leading], 8)
                                    }
                                    .padding(6)
                                }
                                .compositingGroup()
                                .opacity(0.6)
                                .transition(AnyTransition.opacity.animation(.linear(duration: 0.15)))
                            }
                        }
                        
                        VStack(spacing:0) {
                            Divider()
                            
                            if manager.hasItems[0] {
                                if manager.hasItems[1] {
                                    PaneItemSection(section: .primary).environmentObject(manager)
                                        .background(.secondary.opacity(0.05))
                                } else {
                                    PaneItemSection(section: .primary).environmentObject(manager)
                                }
                            }
                            
                            if manager.hasItems[1] {
                                Divider()
                                
                                PaneItemSection(section: .secondary).environmentObject(manager)
                            }
                            
                            if manager.hasItems[2] {
                                Divider()
                                
                                PaneItemSection(section: .tertiary).environmentObject(manager)
                                    .background(.secondary.opacity(0.05))
                            }
                        }
                    }
                    .frame(width: 670)
                    .fixedSize()
                    //                .frame(maxHeight: .infinity)
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.25)))
                    .sheet(isPresented: $avatarSheet) {
                        AvatarView(visible: $avatarSheet, pane: $avatarPane, manager: avatarManager)
                    }
                    .onChange(of: manager.group, perform: { _ in
                        withAnimation() {
                            manager.update(excluding: manager.exclusion)
                            UserDefaults.standard.set(manager.group, forKey: "Group")
                        }
                    })
                    
                }
            } else {
                manager.currentView
                    .transition(AnyTransition.opacity.animation(.linear(duration: 0.25)))
                    .frame(width: 670)
            }
//        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(manager: PaneManager())
    }
}
