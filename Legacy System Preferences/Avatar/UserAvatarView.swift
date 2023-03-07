//
//  UserAvatarView.swift
//  Legacy System Preferences
//
//  Created by BitesPotatoBacks on 3/6/23.
//

import SwiftUI

public struct UserAvatarView: View {
    @Binding public var avatarSheet: Bool
    @State private var showTooltip = false
    
    public let image: Image
    private let user: String = NSFullUserName()

    public var body: some View {
        HStack(alignment: .top) {
            image.resizable()
                .antialiased(true)
                .interpolation(.high)
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
                )
                .padding([.top, .bottom, .leading])
                .padding(.trailing, 4)
                .onTapGesture {
                    avatarSheet.toggle()
                }
            
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

