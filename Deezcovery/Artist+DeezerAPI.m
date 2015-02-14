//
//  Artist+DeezerAPI.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 14/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Artist+DeezerAPI.h"

@implementation Artist (DeezerAPI)

// Return the artist's photo link
- (NSString *)getPhotoLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d/image?size=big", DEEZER_ENDPOINT, (int)[self.artist_id integerValue]];
}

// Return the artist's top tracks link
- (NSString *)getTracksLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d/top", DEEZER_ENDPOINT, (int)[self.artist_id integerValue]];
}

// Return the artist's deezer link
- (NSString *)getArtistLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d", DEEZER_ENDPOINT, (int)[self.artist_id integerValue]];
}

@end
