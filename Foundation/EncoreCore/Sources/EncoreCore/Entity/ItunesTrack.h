//
//  ItunesTrack.h
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

static NSString* _Nonnull const kJsonKeyTrackId = @"trackId";
static NSString* _Nonnull const kJsonKeyArtworkUrl100 = @"artworkUrl100";

@interface ItunesTrack : NSObject
@property(nonatomic)NSUInteger const trackId;
@property(nonatomic)NSURL* _Nonnull const artwork100Url;
- (instancetype _Nonnull)initWithJson:(NSDictionary* _Nonnull const)json;
@end
