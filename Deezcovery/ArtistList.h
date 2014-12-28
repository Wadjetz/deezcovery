//
//  ArtistList.h
//  Deezcovery
//
//  Created by Vuzi on 28/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistList : NSObject

@property NSMutableArray *artists;

- (ArtistList*) initWithArray:(NSArray *) array;
- (void)fillWithArray:(NSArray *) array;

@end
