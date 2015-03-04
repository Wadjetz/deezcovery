//
//  Track.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 14/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Track : NSManagedObject

@property (nonatomic, retain) NSNumber * track_id;      // The track's ID
@property (nonatomic, retain) NSString * title;         // The track's name
@property (nonatomic, retain) NSString * preview;       // Preview string
@property (nonatomic, retain) NSData * preview_data;    // Preview data
@property (nonatomic, retain) NSString * album_title;   // The track album's title
@property (nonatomic, retain) NSNumber * artist_id;     // The artist's ID

@end
