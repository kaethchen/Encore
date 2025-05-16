//
//  ItunesTrackFetcher.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

@class ItunesTrack;

static NSString* _Nonnull const kItunesApiEndpoint = @"https://itunes.apple.com/search?media=music&entity=song&term=";
static NSString* _Nonnull const kItunesApiEndpointKeyResults = @"results";

@interface ItunesTrackFetcher : NSObject
- (void)fetchTrackForTerm:(NSString* _Nonnull const)term completion:(void (^_Nullable const)(ItunesTrack* _Nullable const track))completion;
@end
