//
//  Artist+JsonSerializer.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 21/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Artist+JsonSerializer.h"

@implementation Artist (JsonSerializer)

+ (Artist *)artistFromJson:(NSDictionary *)json {
    if (!json) {
        return nil;
    }
    
    Artist * artist = [[DBManager sharedInstance] createTemporaryObjectWithClass:[Artist class]];
    
    for (id key in json) {
        if([key isEqualToString:@"id"]) {
            artist.artist_id = json[key];
        } else if ([key isEqualToString:@"name"]) {
            artist.name = json[key];
        } else if ([key isEqualToString:@"nb_album"]) {
            artist.nb_album = json[key];
        } else if ([key isEqualToString:@"nb_fan"]) {
            artist.nb_fan = json[key];
        }
    }
    
    return artist;
}

@end

