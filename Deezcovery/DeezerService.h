//
//  DeezerService.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 21/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DEEZER_ENDPOINT @"http://api.deezer.com"

@interface DeezerService : NSObject

+ (NSString *)getPhotoLink:(NSNumber*)artist_id;
+ (NSString *)getTracksLink:(NSNumber*)artist_id;
+ (NSString *)getArtistLink:(NSNumber*)artist_id;

@end
