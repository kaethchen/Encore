//
//  ItunesTrack.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "ItunesTrack.h"

@implementation ItunesTrack
- (instancetype)initWithJson:(NSDictionary* _Nonnull const)json {
    self = [super init];

    if (self) {
        [self setTrackId:[json[kJsonKeyTrackId] intValue]];
        [self setArtwork100Url:[NSURL URLWithString:json[kJsonKeyArtworkUrl100]]];
    }

    return self;
}
@end
