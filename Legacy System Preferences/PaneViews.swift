//
//  PaneViews.swift
//  Legacy System Preferences
//
//  Created by Taevon Turner on 11/11/22.
//

import SwiftUI

struct PreferenceHomeView: View {
    @ObservedObject var prefsList: PaneHandler
    @State var avatarSheet = false
    @State var avatarPane = 0
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                HStack {
                    UserAvatar(img: prefsList.avatar, user: NSFullUserName())
                        .onTapGesture {
                            avatarSheet.toggle()
                        }
                    Spacer()
                    HStack {
                        ForEach(prefsList.header) { pane in
                            PaneItemView(item: pane, hidden: $prefsList.hidden,
                                         editing: $prefsList.editing,
                                         searching: $prefsList.searching,
                                         results: .constant([]))
                                .onTapGesture {
                                    prefsList.manager.loadPreference(pane.path)
                                    if prefsList.manager.applyViewFromPreference() {
                                        prefsList.backwardsHistory.append(prefsList.currentPane)
                                        NSApp.mainWindow?.toolbar?.items[0].isEnabled = true
                                        
                                        prefsList.currentPane = pane.path
                                        NSApp.mainWindow?.title = pane.name
                                        
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
                    
                    if prefsList.hasItems[0] {
                        if prefsList.hasItems[1] {
                            PaneItemSection(section: .primary).environmentObject(prefsList)
                                .background(.secondary.opacity(0.05))
                        } else {
                            PaneItemSection(section: .primary).environmentObject(prefsList)
                        }
                    }
                    
                    if prefsList.hasItems[1] {
                        Divider()
                        
                        PaneItemSection(section: .secondary).environmentObject(prefsList)
                    }
                    
                    if prefsList.hasItems[2] {
                        Divider()
                        
                        PaneItemSection(section: .tertiary).environmentObject(prefsList)
                            .background(.secondary.opacity(0.05))
                    }
                }
            }
            .frame(minWidth: 670, maxWidth: 670, maxHeight: .infinity)
            .sheet(isPresented: $avatarSheet) {
                AvatarView(visible: $avatarSheet, avatar: $prefsList.avatar, pane: $avatarPane)
            }
        }
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
    @Binding var hidden:    [String]
    @Binding var editing:   Bool
    @Binding var searching: Bool
    @Binding var results:   [String]
    @State   var isVisible: Bool = true
    
    var body: some View {
        ZStack {
            
            VStack(alignment:.center) {
                ZStack(alignment:.bottomTrailing) {
                    if item.image != nil {
                        item.image?
                            .resizable()
                            .frame(width: 40, height: 40)
                    }
                    if editing && item.customizable {
                        Toggle(isOn: .init(
                            get: {
                                return isVisible
                            }, set: { value in
                                if hidden.contains(item.id) {
                                    if let idx = hidden.firstIndex(of: item.id) {
                                        hidden.remove(at: idx)
                                    }
                                } else {
                                    hidden.append(item.id)
                                }
                                
                                
                                isVisible.toggle()
                                
                            })) {}
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
            .onAppear() {
                if UserDefaults.standard.object(forKey: "Hidden") != nil {
                    guard let array = UserDefaults.standard.array(forKey: "Hidden") as? [String] else { return }
                    isVisible = !array.contains(item.id)
                }
            }
            
//            if searching {
//                Color.black.opacity(0.75)
//            }
        }
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
                        if prefsList.editing || !prefsList.hidden.contains(pane.id) {
                            PaneItemView(item: pane, hidden: $prefsList.hidden,
                                         editing: $prefsList.editing,
                                         searching: $prefsList.searching,
                                         results: .constant([]))
                                .onTapGesture {
                                    if !prefsList.editing {
                                        prefsList.manager.loadPreference(pane.path)
                                        if prefsList.manager.applyViewFromPreference() {
                                            prefsList.backwardsHistory.append(prefsList.currentPane)
                                            NSApp.mainWindow?.toolbar?.items[0].isEnabled = true
                                            
                                            prefsList.currentPane = pane.path
                                            NSApp.mainWindow?.title = pane.name
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
