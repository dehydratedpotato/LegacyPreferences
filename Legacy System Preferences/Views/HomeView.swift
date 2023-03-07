//
//  HomeView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

public struct HomeView: View {
    @ObservedObject public var manager: PaneManager
    @State private var avatarSheet = false
    @State private var avatarPane: AvatarManager.Pane = .current
    
    @ObservedObject public var avatarManager = AvatarManager()
    
    public var body: some View {
        if manager.selectedPane == nil {
            ZStack {
                VStack(spacing:0) {
                    headerView
                    gridView
                }
                .frame(width: 670)
                .transition(.opacity.animation(.linear(duration: 0.25)))
                .onChange(of: manager.shouldGroup, perform: { value in
                    withAnimation() {
                        manager.update()
                        UserDefaults.standard.set(value, forKey: "Group")
                    }
                })
                .sheet(isPresented: $avatarSheet) {
                    AvatarView(visible: $avatarSheet, pane: $avatarPane)
                        .environmentObject(avatarManager)
                }
            }
        } else {
            manager.selectedPane
                .transition(.opacity.animation(.linear(duration: 0.25)))
                .frame(width: 670)
        }
    }
    
    @ViewBuilder private var headerView: some View {
        ZStack {
            HStack {
                UserAvatarView(avatarSheet: $avatarSheet, image: avatarManager.avatar)
                
                Spacer()
                
                HStack {
                    ForEach(manager.header) { pane in
                        PaneItemView(item: pane)
                        .onTapGesture {
                            let result = manager.openPane(pane: pane)
                            
                            #if DEBUG
                            print("\( result ? "Successfully opened" : "Failed to open") pane \"\(pane.name)\" (\(pane.path) ")
                            #endif
                        }
                    }
                    .padding([.trailing, .leading], 2)
                }
                .padding(.top, 8)
            }
            .padding(6)
            
            if manager.searchQuery != "" {
                ZStack {
                    Color.black
                    
                    HStack {
                        Spacer()
                        
                        ForEach(manager.header) { pane in
                            manager.returnSpotlightFocus(query: manager.searchQuery, pane: pane)
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
                .transition(.opacity.animation(.linear(duration: 0.15)))
                .allowsHitTesting(false)
            }
        }
    }
    
    @ViewBuilder private var gridView: some View {
        VStack(spacing:0) {
            Divider()
            
            if manager.hasItems.0 {
                if manager.hasItems.1 {
                    PaneSectionView(section: .primary).environmentObject(manager)
                        .background(.secondary.opacity(0.05))
                } else {
                    PaneSectionView(section: .primary).environmentObject(manager)
                }
            }
            
            if manager.hasItems.1 {
                Divider()
                
                PaneSectionView(section: .secondary).environmentObject(manager)
            }
            
            if manager.hasItems.2 {
                Divider()
                
                PaneSectionView(section: .tertiary).environmentObject(manager)
                    .background(.secondary.opacity(0.05))
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(manager: PaneManager())
    }
}
