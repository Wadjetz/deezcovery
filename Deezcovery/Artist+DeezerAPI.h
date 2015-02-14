//
//  Artist+DeezerAPI.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 14/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Artist.h"

@interface Artist (DeezerAPI)

- (NSString *)getPhotoLink;
- (NSString *)getTracksLink;
- (NSString *)getArtistLink;

@end
