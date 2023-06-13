//
//  GridView.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/5/23.
//

import SwiftUI

struct PaneGridView: View {
    @ObservedObject var manager: PaneManager
    
    @State private var showsEditSheet = false
    
    var body: some View {
        ZStack(alignment: .top) {
            if let pane = manager.currentPane {
                manager.getView(ofPane: pane)
                    .transition(.opacity.animation(.linear(duration: 0.25)))
            } else {
                VStack(spacing: 0) {
                    header
                        .padding([.top, .leading], PaneConstants.panePadding)
                        .padding(.trailing, 8)
                        .padding(.bottom, 4)
                    
                    grid
                    
                    Spacer()
                }
                .transition(.opacity.animation(.linear(duration: 0.25)))
                .sheet(isPresented: $showsEditSheet) {
                    editSheet
                }
                
            }
        }
        .frame(width: PaneConstants.paneWidth)
    }
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 68))]
    
    @ViewBuilder private var grid: some View {
        VStack(spacing: 0) {
            Divider()
            
            // I know, I really should split this into subviews, but I didn't prioritize that
            if manager.shouldGroup {
                VStack(spacing: 0) {
                    LazyVGrid(columns: columns) {
                        ForEach(manager.primaryPaneList) { pane in
                            if manager.isEditing || !manager.hiddenPanes.contains(pane.type.rawValue) {
                                PaneGridItem(type: pane.type, isEditing: $manager.isEditing)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding([.top], 20)
                    .padding(.bottom, 2)
                    .background(.secondary.opacity(0.05))
                    
                    Divider()
                    
                    LazyVGrid(columns: columns) {
                        ForEach(manager.secondaryPaneList) { pane in
                            if manager.isEditing || !manager.hiddenPanes.contains(pane.type.rawValue) {
                                PaneGridItem(type: pane.type, isEditing: $manager.isEditing)
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding([.top], 20)
                    .padding(.bottom, 2)
                }
                .transition(.opacity.animation(.linear(duration: 0.15)))
            } else {
                LazyVGrid(columns: columns) {
                    ForEach(manager.allPanes) { pane in
                        if manager.isEditing || !manager.hiddenPanes.contains(pane.type.rawValue) {
                            PaneGridItem(type: pane.type, isEditing: $manager.isEditing)
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding([.top], 20)
                .padding(.bottom, 2)
                .transition(.opacity.animation(.linear(duration: 0.15)))
            }
        }
    }
    
    private let username: String = NSFullUserName()
    
    @State private var showEditLabel = false
    
    @ViewBuilder private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            Image("AccountBlank")
                .resizable()
                .frame(width: 68, height: 68)
                .overlay(
                    editLabel
                )
                .onHover {
                    showEditLabel = $0
                }
                .mask(Circle())
                .onTapGesture {
                    showsEditSheet.toggle()
                }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(username)
                    .font(.title2)
                Text("Apple ID, iCloud, Media & App Store")
                    .font(.callout)
                Spacer()
            }
            .padding(.top, 4)
            
            Spacer()
            
            HStack(spacing: 4) {
                PaneGridItem(type: .appleID, isEditing: $manager.isEditing)
                PaneGridItem(type: .familySharing, isEditing: $manager.isEditing)
            }
        }
        .frame(height: 68 + PaneConstants.panePadding)
    }
    
    @ViewBuilder private var editLabel: some View {
        VStack {
            Spacer()
            
            if showEditLabel {
                ZStack {
                    LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 24)
                        .opacity(0.6)
                    Text("edit")
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    @ViewBuilder private var editSheet: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VisualEffectView(material: .sidebar, blendingMode: .withinWindow)
                    .frame(width: 154)
                
                ZStack {
                    VisualEffectView(material: .contentBackground, blendingMode: .withinWindow)
                    Text("Due to Apple ID limitations, this feature will sadly never be completed and is here only for completion")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(10)
                }
            }
            
            HStack {
                Spacer()
                Button("Cancel") {
                    showsEditSheet = false
                }
                Button("Save") {
                }
                .buttonStyle(.borderedProminent)
                .disabled(true)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .frame(width: 458, height: 350)
    }
}


struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        PaneGridView(manager: .shared)
    }
}
