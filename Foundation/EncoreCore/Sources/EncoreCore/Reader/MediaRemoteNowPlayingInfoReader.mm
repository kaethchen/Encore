//
//  MediaRemoteNowPlayingInfoReader.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <AppKit/AppKit.h>
#import "MediaRemote.h"
#import "MediaRemoteNowPlayingInfoReader.hpp"

@implementation MediaRemoteNowPlayingInfoReader
@synthesize bundleId;
@synthesize isPlaying;
@synthesize title;
@synthesize album;
@synthesize artist;
@synthesize duration;
@synthesize elapsed;

- (instancetype)init {
    self = [super init];

    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:kNowPlayingInfoUpdateInterval target:self selector:@selector(read) userInfo:nil repeats:YES];
    }

    return self;
}

- (void)read {
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef const info) {
        if (!info) {
            [self setBundleId:nil];
            [self setIsPlaying:0];
            [self setTitle:nil];
            [self setAlbum:nil];
            [self setArtist:nil];
            [self setDuration:0];
            [self setElapsed:0];

            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameNowPlayingInfoChanged object:nil];
            return;
        }
        NSDictionary* _Nonnull const nowPlayingInfo = (__bridge NSDictionary *)info;

        MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean const isPlaying) {
            MRMediaRemoteGetNowPlayingApplicationPID(dispatch_get_main_queue(), ^(int const Pid) {
                NSString* _Nonnull const bundleId = [[NSRunningApplication runningApplicationWithProcessIdentifier:Pid] bundleIdentifier];
                NSString* _Nonnull const title = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle];
                NSString* _Nonnull const album = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum];
                NSString* _Nonnull const artist = nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist];
                CGFloat const duration = [nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDuration] doubleValue];
                CGFloat const elapsed = [nowPlayingInfo[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] doubleValue];

                if ([self isPlaying] == isPlaying &&
                    [[self title] isEqualToString:title] &&
                    [[self album] isEqualToString:album] &&
                    [[self artist] isEqualToString:artist] &&
                    [self duration] == duration &&
                    [self elapsed] == elapsed
                ) {
                    return;
                }
                
                [self setBundleId:bundleId];
                [self setIsPlaying:isPlaying];
                [self setTitle:title];
                [self setAlbum:album];
                [self setArtist:artist];
                [self setDuration:duration];
                [self setElapsed:elapsed];

                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameNowPlayingInfoChanged object:nil];
            });
        });
    });
}
@end
