//
//  MediaRemote.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT CFStringRef _Nullable const kMRMediaRemoteNowPlayingInfoTitle;
FOUNDATION_EXPORT CFStringRef _Nullable const kMRMediaRemoteNowPlayingInfoAlbum;
FOUNDATION_EXPORT CFStringRef _Nullable const kMRMediaRemoteNowPlayingInfoArtist;
FOUNDATION_EXPORT CFStringRef _Nullable const kMRMediaRemoteNowPlayingInfoDuration;
FOUNDATION_EXPORT CFStringRef _Nullable const kMRMediaRemoteNowPlayingInfoElapsedTime;

typedef void (^ MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef _Nullable const info);
typedef void (^ MRMediaRemoteGetNowPlayingApplicationPIDCompletion)(int const Pid);
typedef void (^ MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion)(Boolean const isPlaying);

FOUNDATION_EXPORT void MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_t _Nullable const queue);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingApplicationPID(dispatch_queue_t _Nullable const queue, MRMediaRemoteGetNowPlayingApplicationPIDCompletion _Nullable const completion);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t _Nullable const queue, MRMediaRemoteGetNowPlayingInfoCompletion _Nullable const completion);
FOUNDATION_EXPORT void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t _Nullable const queue, MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion _Nullable const completion);
