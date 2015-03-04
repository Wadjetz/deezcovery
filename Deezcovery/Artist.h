//
//  Artist.h
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Artist : NSManagedObject

@property (nonatomic) NSNumber *artist_id;    // The artist's ID
@property (nonatomic, strong) NSString *name; // The artist's name
@property (nonatomic) NSNumber *nb_album;     // The number of albums the artist has
@property (nonatomic) NSNumber *nb_fan;       // The number of fans the artist has

@end
