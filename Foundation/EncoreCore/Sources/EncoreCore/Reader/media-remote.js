//
//  MediaRemote.js
//  EncoreCore
//
//  Created by EinTim23, Alexandra Göttlicher
//

ObjC.import('Foundation');

try {
    const frameworkPath = '/System/Library/PrivateFrameworks/MediaRemote.framework';
    const framework = $.NSBundle.bundleWithPath($(frameworkPath));
    framework.load

    const MRNowPlayingRequest = $.NSClassFromString('MRNowPlayingRequest');
    const playerPath = MRNowPlayingRequest.localNowPlayingPlayerPath;
    const nowPlayingItem = MRNowPlayingRequest.localNowPlayingItem;

    const nowPlayingInfo = nowPlayingItem.nowPlayingInfo;

    const bundleId = ObjC.unwrap(playerPath.client.bundleIdentifier);
    const isPlaying = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoPlaybackRate');
    const title = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoTitle');
    const album = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoAlbum');
    const artist = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoArtist');
    const duration = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoDuration');
    const elapsed = nowPlayingInfo.valueForKey('kMRMediaRemoteNowPlayingInfoElapsedTime');

    JSON.stringify({
        bundle_id: ObjC.unwrap(bundleId),
        is_playing: ObjC.unwrap(isPlaying),
        title: ObjC.unwrap(title),
        album: ObjC.unwrap(album),
        artist: ObjC.unwrap(artist),
        duration: ObjC.unwrap(duration),
        elapsed: ObjC.unwrap(elapsed)
    });
} catch (error) {
    JSON.stringify({
        player: null,
        error: error.toString()
    });
}
