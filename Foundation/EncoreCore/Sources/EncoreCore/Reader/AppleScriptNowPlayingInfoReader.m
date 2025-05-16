//
//  AppleScriptNowPlayingInfoReader.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "AppleScriptNowPlayingInfoReader.h"

@implementation AppleScriptNowPlayingInfoReader
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
    NSTask* _Nonnull const task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/osascript"];
    [task setArguments:@[@"-l", @"JavaScript", [[NSBundle mainBundle] pathForResource:@"media-remote" ofType:@"js"]]];

    NSPipe* _Nonnull const pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:[NSPipe pipe]];
    [task launch];
    [task waitUntilExit];

    NSData* _Nonnull const data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString* _Nonnull const output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData* _Nonnull const jsonData = [output dataUsingEncoding:NSUTF8StringEncoding];
    NSError* _Nullable error = nil;
    NSDictionary* _Nullable const json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

    if (error || !json[kNowPlayingInfoKeyBundleId]) {
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

    NSString* _Nonnull const bundleId = json[kNowPlayingInfoKeyBundleId];
    BOOL const isPlaying = [json[kNowPlayingInfoKeyIsPlaying] boolValue];
    NSString* _Nonnull const title = json[kNowPlayingInfoKeyTitle];
    NSString* _Nonnull const album = json[kNowPlayingInfoKeyAlbum];
    NSString* _Nonnull const artist = json[kNowPlayingInfoKeyArtist];
    CGFloat const duration = [json[kNowPlayingInfoKeyDuration] doubleValue];
    CGFloat const elapsed = [json[kNowPlayingInfoKeyElapsed] doubleValue];

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
}
@end
