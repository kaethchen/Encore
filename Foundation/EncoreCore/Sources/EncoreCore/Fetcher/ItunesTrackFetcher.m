//
//  ItunesTrackFetcher.m
//  EncoreCore
//
//  Created by Alexandra Göttlicher
//

#import "ItunesTrackFetcher.h"
#import "../Entity/ItunesTrack.h"

@implementation ItunesTrackFetcher
- (void)fetchTrackForTerm:(NSString* _Nonnull const)term completion:(void (^_Nullable const)(ItunesTrack* _Nullable const track))completion {
    NSURL* _Nonnull const url = [NSURL URLWithString:[kItunesApiEndpoint stringByAppendingString:term]];
    dispatch_group_t const sync = dispatch_group_create();
    dispatch_group_enter(sync);

    NSURLSessionDataTask* _Nonnull const task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData* _Nullable const data, NSURLResponse* _Nullable const response, NSError* _Nullable error) {
        if (error) {
            completion(nil);
            dispatch_group_leave(sync);
            return;
        }

        NSDictionary* _Nullable const json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            completion(nil);
            dispatch_group_leave(sync);
            return;
        }

        NSArray* _Nonnull const results = json[kItunesApiEndpointKeyResults];
        if ([results count] > 0) {
            ItunesTrack* _Nonnull const track = [[ItunesTrack alloc] initWithJson:results[0]];
            completion(track);
            dispatch_group_leave(sync);
            return;
        }

        completion(nil);
        dispatch_group_leave(sync);
    }];

    [task resume];
    dispatch_group_wait(sync, DISPATCH_TIME_FOREVER);
}
@end
