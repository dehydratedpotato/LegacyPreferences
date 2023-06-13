//
//  PaneSidebarItem.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import SwiftUI

struct PaneSidebarItem: View {
    let image: String
    let name: String
    
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack(spacing: 6) {
                Image(image)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(name)
                
                Spacer()
            }
        })
        .buttonStyle(.plain)
    }
}

struct PaneSidebarItem_Previews: PreviewProvider {
    static var previews: some View {
        PaneSidebarItem(image: "", name: "")
    }
}
