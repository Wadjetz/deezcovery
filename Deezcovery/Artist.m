//
//  Artist.m
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "Artist.h"
#import "DeezerApi.h"

@implementation Artist

// Init the artist with the given NSDictionary, usually coming from an API request
- (Artist *)initWithDictionary:(NSDictionary *) dictionary {
    
    self = [self init];
    
    if(dictionary) {
        if([dictionary objectForKey:@"id"])
            self.artist_id = (int)[(NSNumber*)dictionary[@"id"] integerValue];
        
        if([dictionary objectForKey:@"name"])
            self.name = (NSString*)dictionary[@"name"];
        
        if([dictionary objectForKey:@"nb_album"])
            self.nb_album = (int)[(NSNumber*)dictionary[@"nb_album"] integerValue];
        
        if([dictionary objectForKey:@"nb_fan"])
            self.nb_fan = (int)[(NSNumber*)dictionary[@"nb_fan"] integerValue];
    }
    
    return self;
}

// Return the artist's photo link
- (NSString *)getPhotoLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d/image?size=big", DEEZER_ENDPOINT, self.artist_id];
}

// Return the artist's top tracks link
- (NSString *)getTracksLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d/top", DEEZER_ENDPOINT, self.artist_id];
}

// Return the artist's deezer link
- (NSString *)getArtistLink {
    return [[NSString alloc]initWithFormat:@"%@/artist/%d", DEEZER_ENDPOINT, self.artist_id];
}

@end
