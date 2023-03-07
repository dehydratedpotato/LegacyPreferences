//
//  PaneSectionView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 3/6/23.
//

import SwiftUI

public struct PaneSectionView: View {
    @EnvironmentObject var manager: PaneManager
    
    @State public var section: PaneItem.Section
    @State private var filter: [BundleData.Identifiers : Bool] = [:]
    
    private let columns: [GridItem] = [GridItem(.adaptive(minimum: 68))]
    
    public var body: some View {
        ZStack {
            LazyVGrid(columns: columns) {
                paneList
            }
            .padding([.trailing, .leading], 8)
            .padding([.top], 20)
            .padding(.bottom, 2)
            
            if manager.searchQuery != "" {
                ZStack {
                    Color.black
                    
                    LazyVGrid(columns: columns) {
                        paneFocusList
                    }
                    .padding([.leading, .trailing], 8)
                    
                }
                .compositingGroup()
                .transition(.opacity.animation(.linear(duration: 0.15)))
                .opacity(0.6)
                .allowsHitTesting(false)
            }
        }
    }
    
    @ViewBuilder private var paneList: some View {
        ForEach(manager.collection) { pane in
            if pane.section == section {
                if manager.isEditing || !manager.hiddenPanes.contains(pane.id) {
                    PaneItemView(item: pane)
                        .onTapGesture {
                            if !manager.isEditing {
                                let result = manager.openPane(pane: pane)
#if DEBUG
                                print("\( result ? "Successfully opened" : "Failed to open") pane \"\(pane.name)\" (\(pane.path) ")
#endif
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder private var paneFocusList: some View {
        ForEach(manager.collection) { pane in
            if pane.section == section {
                
                if manager.isEditing || !manager.hiddenPanes.contains(pane.id) {
                    manager.returnSpotlightFocus(query: manager.searchQuery, pane: pane)
                        .scaleEffect(2)
                        .padding(.bottom, 12)
                        .blendMode(.destinationOut)
                }
            }
        }
    }
}
