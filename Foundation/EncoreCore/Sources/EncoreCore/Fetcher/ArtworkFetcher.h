//
//  ArtworkFetcher.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class ItunesTrack;

@interface ArtworkFetcher : NSObject
- (void)fetchItunesArtworkForTrack:(ItunesTrack* _Nonnull const)track completion:(void (^_Nonnull const)(NSURL* _Nonnull const artworkUrl))completion;
@end
