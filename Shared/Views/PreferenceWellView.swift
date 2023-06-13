//
//  PreferenceWell.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/7/23.
//

import SwiftUI

struct PreferenceWellView<V: View>: View {
    let subheadline: String?
    
    @ViewBuilder var view: V
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let string = subheadline {
                Text(string)
                    .font(.subheadline)
                    .padding([.top, .leading], 14)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.secondary.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.secondary.opacity(0.175), style: .init(lineWidth: 1))
                    )
                
                HStack {
                    view
                        .padding(.leading, 16)
                    Spacer()
                }
            }
        }
    }
}
//
//struct PreferenceWell_Previews: PreviewProvider {
//    static var previews: some View {
//        PreferenceWell()
//    }
//}
