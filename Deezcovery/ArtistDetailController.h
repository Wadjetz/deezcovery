//
//  ArtistDetailController.h
//  Deezcovery
//
//  Created by Vuzi on 28/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Artist.h"
#import "Track.h"
#import "Track+JsonSerializer.h"
#import "DeezerService.h"
#import "DBManager.h"

@interface ArtistDetailController : UIViewController

@property (strong, nonatomic) Artist* artist;   // Artist loaded from the deezer api
@property (strong, nonatomic) Artist* dbArtist; // Artist loaded from local

@property (strong, nonatomic) NSNumber* currentArtistId;       // Artist's ID
@property (strong, nonatomic) NSString* currentArtistName;     // Artist's name
@property (strong, nonatomic) NSNumber* currentArtistNbAlbums; // Artist's number of albums
@property (strong, nonatomic) NSNumber* currentArtistNbFan;    // Artist's number of fans

@property (strong, nonatomic) DBManager* db;   // Database manager

@property (strong, nonatomic) IBOutlet UILabel *artistName;         // Artist name's label
@property (strong, nonatomic) IBOutlet UIImageView *artistImage;    // Artist image's label
@property (strong, nonatomic) IBOutlet UILabel *nbFans;             // Artist number of fans
@property (strong, nonatomic) IBOutlet UILabel *nbAlbums;           // Artist number of albums
@property (strong, nonatomic) IBOutlet UISwitch *onOfFavorisSwitch; // Favorite switch

@end
