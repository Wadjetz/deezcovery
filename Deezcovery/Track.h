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

@property (nonatomic, retain) NSNumber * track_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * preview;
@property (nonatomic, retain) NSString * album_title;
@property (nonatomic, retain) NSNumber * artist_id;

@end
