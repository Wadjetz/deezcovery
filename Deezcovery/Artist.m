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
            self.artist_id = (NSNumber*)dictionary[@"id"];
        
        if([dictionary objectForKey:@"name"])
            self.name = (NSString*)dictionary[@"name"];
        
        if([dictionary objectForKey:@"nb_album"])
            self.nb_album = (NSNumber*)dictionary[@"nb_album"];
        
        if([dictionary objectForKey:@"nb_fan"])
            self.nb_fan = (NSNumber*)dictionary[@"nb_fan"];
    }
    
    return self;
}

@end
