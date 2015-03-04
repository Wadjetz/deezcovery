//
//  Track+JsonSerializer.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Track+JsonSerializer.h"

@implementation Track (JsonSerializer)

+ (Track *)trackFromJson:(NSDictionary *)json {
    if (!json) {
        return nil;
    }
    
    Track * track = [[DBManager sharedInstance] createTemporaryObjectWithClass:[Track class]];
    
    for (id key in json) {
        if([key isEqualToString:@"id"]) {
            track.track_id = json[key];
        } else if ([key isEqualToString:@"title"]) {
            track.title = json[key];
        } else if ([key isEqualToString:@"preview"]) {
            track.preview = json[key];
        } else if ([key isEqualToString:@"album"]) {
            track.album_title = json[key][@"title"];
        }
    }
    
    return track;
}

@end
