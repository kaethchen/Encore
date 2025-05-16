//
//  ArtworkFetcher.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "ArtworkFetcher.h"
#import "../Entity/ItunesTrack.h"

@implementation ArtworkFetcher
- (void)fetchItunesArtworkForTrack:(ItunesTrack* _Nonnull const)track completion:(void (^_Nonnull const)(NSURL* _Nonnull const artworkUrl))completion {
    completion([track artwork100Url]);
}
@end
