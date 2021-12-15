//
//  SpotifyApp.swift
//  Shared
//
//  Created by Vladislav Likh on 09/12/21.
//

import SwiftUI

@main
struct SpotifyApp: App {
    var body: some Scene {
        WindowGroup {
            NewListView().environmentObject(PlayerViewModel())
        }
    }
}
