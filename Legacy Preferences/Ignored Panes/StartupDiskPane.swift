//
//  StartupDiskPane.swift
//  Legacy Preferences
//
//  Created by dehydratedpotato on 6/6/23.
//

import SwiftUI

struct StartupDiskPane: View {
    var body: some View {
        VStack {
            UnavailableLabel()
        }
        .frame(width: PaneConstants.paneWidth, height: 428)
        .navigationTitle(PaneConstants.nameTable[PaneConstants.PaneType.startupDisk.rawValue])
    }
}

struct StartupDiskPane_Previews: PreviewProvider {
    static var previews: some View {
        StartupDiskPane()
    }
}
