//
//  Artist+DeezerAPI.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 14/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Artist.h"
#import "DeezerApi.h"

@interface Artist (DeezerAPI)

+ (NSString *)getPhotoLink:(NSNumber*)artist_id;
+ (NSString *)getTracksLink:(NSNumber*)artist_id;
+ (NSString *)getArtistLink:(NSNumber*)artist_id;

@end
