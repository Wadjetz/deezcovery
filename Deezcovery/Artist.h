//
//  Artist.h
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeezerApi.h"

@interface Artist : NSObject

// -- Properties --
// The artist id, used to get its informations with the deezer api
@property (nonatomic) int artist_id;

// The artist's name
@property (nonatomic, strong) NSString *name;

// The number of albums the artist has
@property (nonatomic) int nb_album;

// The number of fans the artist has
@property (nonatomic) int nb_fan;

// -- Prototypes --
- (Artist *)initWithDictionary:(NSDictionary *) dictionary;

- (NSString *)getPhotoLink;
- (NSString *)getTracksLink;
- (NSString *)getArtistLink;

@end
