//
//  PaneItemView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 3/6/23.
//

import SwiftUI

public struct PaneItemView: View {
    public let item: PaneItem
    
    @StateObject public var paneManager: PaneManager
    
    @State private var isVisible: Bool = true
    
    init(item: PaneItem) {
        self.item = item
        
        self._paneManager = .init(wrappedValue: .shared)
    }
    
    public var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                if let icon = item.appIcon {
                    icon.resizable()
                        .frame(width: 40, height: 40)
                }
                
                if paneManager.isEditing && item.customizable {
                    Toggle(isOn: .init(get: {
                        return isVisible
                    }, set: { newValue in
                        if let idx = paneManager.hiddenPanes.firstIndex(of: item.id) {
                            paneManager.hiddenPanes.remove(at: idx)
                        } else {
                            paneManager.hiddenPanes.append(item.id)
                        }
                        
                        UserDefaults.standard.set(paneManager.hiddenPanes, forKey: "Hidden")
                        isVisible.toggle()
                        
                    }), label: {
                        //
                    })
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
        .frame(width: 76, height: 85)
        .onAppear() {
            if let array = UserDefaults.standard.array(forKey: "Hidden") as? [String] {
                isVisible = !array.contains(item.id)
            }
        }
    }
}
