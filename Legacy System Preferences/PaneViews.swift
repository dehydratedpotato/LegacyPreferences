//
//  PaneViews.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import SwiftUI

struct PreferenceHomeView: View {
    @ObservedObject var prefsList: PaneHandler
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                UserAvatar(user: NSFullUserName())
                Spacer()
                HStack {
                    ForEach(prefsList.header) { pane in
                        PaneItemView(item: pane)
                            .onTapGesture {
                                prefsList.manager.loadPreference(pane.path)
                                if prefsList.manager.applyViewFromPreference() {
                                    prefsList.backwardsHistory.append(pane.path)
                                    prefsList.currentPane = pane.path
                                    
                                    print(prefsList.backwardsHistory)
                                }
                            }
                    }
                }
                .padding(.top, 8)
            }
            .padding(6)
            
            VStack(spacing:0) {
                Divider()
                
                PaneItemSection(section: .primary).environmentObject(prefsList)
                    .background(.secondary.opacity(0.05))
                
                Divider()
                
                PaneItemSection(section: .secondary).environmentObject(prefsList)

                if prefsList.hasTertiaryItems {
                    Divider()
                    
                    PaneItemSection(section: .tertiary).environmentObject(prefsList)
                        .background(.secondary.opacity(0.05))
                }
            }
            
            Spacer()
        }
        .frame(minWidth: 670, maxWidth: 670, maxHeight: .infinity)
    }
}

struct UserAvatar: View {
    @State var user: String
    @State private var showTooltip = false
    
    var body: some View {
        HStack(alignment: .top) {
//            Image(systemName: "")
//                .resizable()
            Circle()
                .onHover {
                    showTooltip = $0
                }
                .frame(width: 65, height: 65)
                .foregroundColor(.white)
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
                        .mask (
                            Circle()
                        )
                )
//                .mask(
//                    Circle()
//                        .onHover {
//                            showTooltip = $0
//                        }
//                )
                .padding([.top, .bottom, .leading])
                .padding(.trailing, 4)
            
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

struct PaneItemView: View {
    let item: PaneItem
    
    var body: some View {
        VStack(alignment:.center) {
            if item.image != nil {
                item.image?
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            Text(item.name)
                .font(.callout)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(width: 76)
        .frame(height:85)
    }
}

struct PaneItemSection: View {
    @EnvironmentObject var prefsList: PaneHandler
    @State             var section:   PaneSection
    
    var body: some View {
        VStack(spacing:0) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 68))]) {
                ForEach(prefsList.collection) { pane in
                    if pane.section == section {
                        PaneItemView(item: pane)
                            .onTapGesture {
                                prefsList.manager.loadPreference(pane.path)
                                if prefsList.manager.applyViewFromPreference() {
                                    prefsList.backwardsHistory.append(pane.path)
                                    prefsList.currentPane = pane.path
                                    
                                    print(prefsList.backwardsHistory)
                                }
                            }
                    }
                }
            }
            .padding([.trailing, .leading], 8)
            .padding([.top], 20)
            .padding(.bottom, 2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceHomeView(prefsList: PaneHandler())
    }
}
