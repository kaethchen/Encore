//
//  EncoreCore.mm
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "EncoreCore.hpp"
#import "Entity/ItunesTrack.h"
#import "Fetcher/ItunesTrackFetcher.h"
#import "Fetcher/ArtworkFetcher.h"
#import "Reader/AppleScriptNowPlayingInfoReader.h"
#import "Reader/MediaRemoteNowPlayingInfoReader.hpp"
#import "SwiftRPC.h"

@implementation EncoreCore
- (instancetype _Nonnull)init {
    self = [super init];

    if (self) {
        _threadVersion = 0;
        _iTunesTrackFetcher = [[ItunesTrackFetcher alloc] init];
        _artworkFetcher = [[ArtworkFetcher alloc] init];

        if (@available(macOS 15, *)) {
            [self setNowPlayingInfoReader:[[AppleScriptNowPlayingInfoReader alloc] init]];
        } else {
            [self setNowPlayingInfoReader:[[MediaRemoteNowPlayingInfoReader alloc] init]];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlayingInfoChanged) name:kNotificationNameNowPlayingInfoChanged object:nil];
    }

    return self;
}

- (void)connect {
    NSString* _Nullable clientId = kClientIdNone;
    for (;;) {
        clientId = [self getClientId];
        if (kClientIdNone != clientId) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    for (;;) {
        DiscordEventHandlers discordHandler{};
        Discord_Initialize([clientId UTF8String], &discordHandler);
        if (Discord_IsConnected()) {
            break;
        }
        sleep(kTimeoutReconnect);
    }

    // Run callbacks as long as the "thread version" doesn't change.
    // The version is increased every time a new valid app starts playing.
    // This way the current thread is terminated.
    NSUInteger const currentThreadVersion = _threadVersion;
    while (currentThreadVersion == _threadVersion) {
        // Re-initialize the RPC when the connection to the Discord client is lost.
        Discord_RunCallbacks();
        if (!Discord_IsConnected()) {
            [self connect];
        }
        sleep(kTimeoutCallback);
    }
}

- (NSString *)getClientId {
    return @"1368861022256889906";
}

- (void)nowPlayingInfoChanged {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![[self nowPlayingInfoReader] isPlaying]) {
            if (Discord_IsConnected()) {
                _threadVersion++;
                Discord_Shutdown();
            }
            return;
        }

        if (!Discord_IsConnected()) {
            [self connect];
        }

        [self updateRichPresence];
    });
}

- (void)updateRichPresence {
    NSString* _Nonnull queryParameter = [NSString stringWithFormat:@"%@ %@ %@", [[self nowPlayingInfoReader] title], [[self nowPlayingInfoReader] album], [[self nowPlayingInfoReader] artist]];
    // The iTunes API doesn't return any result if * is included.
    queryParameter = [queryParameter stringByReplacingOccurrencesOfString:@"*" withString:@""];
    queryParameter = [queryParameter stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    __block DiscordRichPresence activity{};
    activity.type = LISTENING;
    activity.details = [[[self nowPlayingInfoReader] title] UTF8String];
    activity.state = [[[self nowPlayingInfoReader] artist] UTF8String];
    activity.largeImageText = [[[self nowPlayingInfoReader] album] UTF8String];
    activity.button1name = [@"Search on TIDAL" UTF8String];
    activity.button1link = [[@"https://tidal.com/search?q=" stringByAppendingString:queryParameter] UTF8String];

    if ([[self nowPlayingInfoReader] duration] > 0) {
        CGFloat const remainingTime = [[self nowPlayingInfoReader] duration] - [[self nowPlayingInfoReader] elapsed];
        activity.endTimestamp = time(nullptr) + (NSUInteger)remainingTime;
        activity.startTimestamp = time(nullptr) - (NSUInteger)[[self nowPlayingInfoReader] elapsed];
    }

    __block NSString* _Nonnull largeImageKey = nil;
    [_iTunesTrackFetcher fetchTrackForTerm:queryParameter completion:^(ItunesTrack* _Nullable const track) {
        if (track) {
            [_artworkFetcher fetchItunesArtworkForTrack:track completion:^(NSURL* _Nullable const artworkUrl) {
                if (artworkUrl) {
                    largeImageKey = [artworkUrl absoluteString];
                    activity.largeImageKey = [largeImageKey UTF8String];
                    activity.smallImageKey = [@"appicon" UTF8String];
                    activity.smallImageText = [@"TIDAL" UTF8String];
                }
            }];
        } else {
            activity.largeImageKey = [@"appicon" UTF8String];
        }
    }];

    __block NSString* _Nonnull button1Link = nil;
    [_iTunesTrackFetcher fetchTrackForTerm:queryParameter completion:^(ItunesTrack* _Nullable const track) {
        if (track) {
            button1Link = [NSString stringWithFormat:@"https://song.link/i/%lu", [track trackId]];
            activity.button2name = [@"View on Odesli" UTF8String];
            activity.button2link = [button1Link UTF8String];
        }
    }];

    Discord_UpdatePresence(&activity);
}
@end
