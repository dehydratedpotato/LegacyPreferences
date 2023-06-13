//
//  UnavailableLabel.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import SwiftUI

struct UnavailableLabel: View {
    var body: some View {
        HStack {
            Spacer()
            Text("This pane will sadly never be completed and is here only for completion")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct UnavailableLabel_Previews: PreviewProvider {
    static var previews: some View {
        UnavailableLabel()
    }
}
