//
//  DeezerService.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 21/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "DeezerService.h"

@implementation DeezerService

// Return the artist's photo link
+ (NSString *)getPhotoLink:(NSNumber*)artist_id {
    return [[NSString alloc]initWithFormat:@"%@/artist/%@/image?size=big", DEEZER_ENDPOINT, artist_id];
}

// Return the artist's top tracks link
+ (NSString *)getTracksLink:(NSNumber*)artist_id {
    return [[NSString alloc]initWithFormat:@"%@/artist/%@/top", DEEZER_ENDPOINT, artist_id];
}

// Return the artist's deezer link
+ (NSString *)getArtistLink:(NSNumber*)artist_id {
    return [[NSString alloc]initWithFormat:@"%@/artist/%@", DEEZER_ENDPOINT, artist_id];
}

// Return the artist's related other artists
+ (NSString *)getArtistsRelated:(NSNumber*)artist_id {
    return [[NSString alloc]initWithFormat:@"%@/artist/%@/related", DEEZER_ENDPOINT, artist_id];
}

@end
