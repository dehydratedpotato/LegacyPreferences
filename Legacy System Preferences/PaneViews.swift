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
                UserAvatar(img: prefsList.getUserAvatar(), user: NSFullUserName())
                Spacer()
                HStack {
                    ForEach(prefsList.header) { pane in
                        PaneItemView(item: pane, allItems: $prefsList.collection, editing: $prefsList.editing)
                            .onTapGesture {
                                prefsList.manager.loadPreference(pane.path)
                                if prefsList.manager.applyViewFromPreference() {
                                    prefsList.backwardsHistory.append(pane.path)
                                    prefsList.currentPane = pane.path
                                    NSApplication.shared.windows[0].title = pane.name
                                    
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
                
                if prefsList.hasSecondaryItems {
                    PaneItemSection(section: .primary).environmentObject(prefsList)
                        .background(.secondary.opacity(0.05))
                } else {
                    PaneItemSection(section: .primary).environmentObject(prefsList)
                }
                
                if prefsList.hasSecondaryItems {
                    Divider()
                    
                    PaneItemSection(section: .secondary).environmentObject(prefsList)
                }

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
    @State var img: Image
    @State var user: String
    @State private var showTooltip = false
    
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
    @Binding var allItems: [PaneItem]
    @Binding var editing: Bool
    
    var body: some View {
        VStack(alignment:.center) {
            ZStack(alignment:.bottomTrailing) {
                if item.image != nil {
                    item.image?
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                if editing && item.customizable {
                    // this line is something alright...
                    Toggle(isOn: $allItems[allItems.firstIndex(where: { $0.id == item.id }) ?? (allItems.firstIndex(where: { $0.name == item.name }) ?? 0)].visible ) {}
                        .toggleStyle(.checkbox)
                }
            }
            .frame(width: 40, height: 40)
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
    @State             var filter:    [AppleBundleIDs:Bool] = [:]
    
    var body: some View {
        VStack(spacing:0) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 68))]) {
                ForEach(prefsList.collection) { pane in
                    if pane.section == section {
                        if prefsList.editing || pane.visible {
                            PaneItemView(item: pane, allItems: $prefsList.collection, editing: $prefsList.editing)
                                .onTapGesture {
                                    if !prefsList.editing {
                                        prefsList.manager.loadPreference(pane.path)
                                        if prefsList.manager.applyViewFromPreference() {
                                            prefsList.backwardsHistory.append(pane.path)
                                            prefsList.currentPane = pane.path
                                            NSApplication.shared.windows[0].title = pane.name
                                            
                                            print(prefsList.backwardsHistory)
                                        }
                                    }
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
