//
//  DBManager.h
//  Deezcovery
//
//  Created by Vuzi on 03/01/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "ArtistList.h"
#import "Artist.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(instancetype) initWithDatabaseFilename:(NSString*) dbFilename;

-(ArtistList*) loadArtistsFromDBfrom:(int) from size:(int)size;
-(Artist*) loadArtistFromDB:(int) ID;
-(void) saveArtist:(Artist*) artist;
-(void) deleteArtist:(Artist*) artist;

@end
