//
//  PaneItemViews.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 12/23/22.
//

import SwiftUI

struct PaneItemView: View {
    let item: PaneItem
    @Binding var hidden:    [String]
    @Binding var editing:   Bool
    @Binding var search: String
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
                                
                                UserDefaults.standard.set(hidden, forKey: "Hidden")
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
        }
    }
}

struct PaneItemSection: View {
    @EnvironmentObject var manager:   PaneManager
    @State             var section:   PaneSection
    @State             var filter:    [AppleBundleIDs:Bool] = [:]
    
    var body: some View {
        ZStack {
            VStack(spacing:0) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 68))]) {
                    ForEach(manager.collection) { pane in
                        if pane.section == section {
                            if manager.editing || !manager.hidden.contains(pane.id) {
                                PaneItemView(item: pane, hidden: $manager.hidden,
                                             editing: $manager.editing,
                                             search: $manager.query,
                                             results: .constant([]))
                                .onTapGesture {
                                    if !manager.editing {
                                        print("\(manager.openPane(pane: pane) ? "Successfully opened" : "Failed to open") pane \"\(pane.name)\" (\(pane.path) ")
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
            
            if manager.query != "" {
                ZStack {
                    Color.black
                    VStack(spacing:0) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 68))]) {
                            ForEach(manager.collection) { pane in
                                if pane.section == section {
                                    if manager.editing || !manager.hidden.contains(pane.id) {
                                        manager.returnSpotlightFocus(query: manager.query, pane: pane)
                                            .scaleEffect(2)
                                            .padding(.bottom, 12)
                                            .blendMode(.destinationOut)
                                    }
                                }
                            }
                        }
                        .padding([.trailing, .leading], 8)
                    }
                }
                .compositingGroup()
                .opacity(0.6)
                .transition(AnyTransition.opacity.animation(.linear(duration: 0.15)))
            }
        }
    }
}
