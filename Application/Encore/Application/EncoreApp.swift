//
//  EncoreApp.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

// TODO: add caching
// TODO: preferences
// TODO: handle client ids
// TODO: check what happens if switching playing apps too rapidly (it may stay on the same client id)
// TODO: add website support
// TODO: add lastfm scrobbling

// TODO: set minimum swift tools version
// TODO: app icon & menu bar icon
// TODO: documentation
// TODO: add swiftrpc via git

@main
internal struct EncoreApp: App {
    private let bridge: EncoreCoreBridge = .init()

    internal var body: some Scene {
        MenuBarExtra(Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String, systemImage: "music.note") {
            MainMenuBarView(bridge: self.bridge)
        }

        WindowGroup("Preferences", id: "preferences") {
            PreferencesView()
        }
        .handlesExternalEvents(matching: ["preferences"])
    }
}
