//
//  ArtistList.m
//  Deezcovery
//
//  Created by Vuzi on 28/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistList.h"
#import "Artist.h"

@implementation ArtistList

- (ArtistList*) initWithArray:(NSArray *) array {

    self = [self init];
    [self fillWithArray:array];
    
    return self;
}

- (void)fillWithArray:(NSArray *) array {
    
    if(self.artists) {
        [self.artists removeAllObjects];
    } else {
        self.artists = [[NSMutableArray alloc] init];
    }
    
    for(id value in array) {
        [self.artists addObject:[[Artist alloc] initWithDictionary:(NSDictionary*)value]];
    }
    
}

@end
