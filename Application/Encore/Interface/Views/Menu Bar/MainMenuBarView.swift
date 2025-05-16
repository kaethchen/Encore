//
//  MainMenuBarView.swift
//  Encore
//
//  Created by Alexandra Göttlicher
//

import EncoreCoreBridge
import SwiftUI

internal struct MainMenuBarView: View {
    @ObservedObject internal var bridge: EncoreCoreBridge

    internal var body: some View {
        VStack {
            if self.bridge.title != nil && self.bridge.album != nil && self.bridge.artist != nil {
                if self.bridge.isPlaying! {
                    Text("MAIN_MENU_BAR_NOW_PLAYING")
                } else {
                    Text("MAIN_MENU_BAR_PAUSED")
                }
                Text(self.bridge.title!)
                Text("\(self.bridge.artist!) — \(self.bridge.album!)")
            } else {
                Text("MAIN_MENU_BAR_NOT_PLAYING")
            }

            Divider()

            Button(String(format: String(localized: "MAIN_MENU_BAR_ABOUT"), Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)) {
                NSApp.orderFrontStandardAboutPanel()
            }
            Button("MAIN_MENU_BAR_PREFERENCES") {
                NSWorkspace.shared.open(URL(string: "encore://preferences")!)
            }
            .keyboardShortcut(.init(",", modifiers: [.command]))

            Divider()

            Button(String(format: String(localized: "MAIN_MENU_BAR_QUIT"), Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String)) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut(.init("q", modifiers: [.command]))
        }
    }
}
