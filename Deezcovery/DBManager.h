//
//  DBManager.h
//  Deezcovery
//
//  Created by Vuzi on 03/01/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Artist.h"
#import "Track.h"

@interface DBManager : NSObject

+ (id)sharedInstance;

- (void)deleteManagedObject:(NSManagedObject *)object;

- (id)createManagedObjectWithName:(NSString *)entityName;
- (id)createManagedObjectWithClass:(Class)entityClass;
- (id)createTemporaryObjectWithClass:(Class)entityClass;

- (BOOL)persistData;
- (void)refreshObject:(NSManagedObject *)managedObject mergeChanges:(BOOL)flag;

- (void)saveTrack:(Track *)track forArtist:(Artist *)artist;
- (NSArray *)getTracks:(Artist *)artist;


- (void)saveArtist:(Artist *)artist;
- (void)saveArtist:(NSNumber *)artist_id with:(NSString*)name with:(NSNumber *)nb_album with:(NSNumber *)nb_fan;
- (NSArray *)fetchArtists;
- (Artist *)getArtist:(NSNumber *)artist_id;

@end