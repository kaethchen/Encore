//
//  EncoreCoreBridge.swift
//  EncoreCoreBridge
//
//  Created by Alexandra Göttlicher
//

import EncoreCore
import SwiftUI

public class EncoreCoreBridge: ObservableObject {
    private let core: EncoreCore = .init()

    @Published public var bundleId: String?
    @Published public var isPlaying: Bool?
    @Published public var title: String?
    @Published public var album: String?
    @Published public var artist: String?
    @Published public var duration: CGFloat?
    @Published public var elapsed: CGFloat?

    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(nowPlayingInfoChanged), name: Notification.Name(kNotificationNameNowPlayingInfoChanged), object: nil)
    }

    @objc private func nowPlayingInfoChanged() -> Void {
        self.bundleId = core.nowPlayingInfoReader.bundleId
        self.isPlaying = core.nowPlayingInfoReader.isPlaying
        self.title = core.nowPlayingInfoReader.title
        self.album = core.nowPlayingInfoReader.album
        self.artist = core.nowPlayingInfoReader.artist
        self.duration = core.nowPlayingInfoReader.duration
        self.elapsed = core.nowPlayingInfoReader.elapsed
    }
}
