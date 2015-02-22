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

@property (strong, nonatomic) Artist* artist;
@property (strong, nonatomic) Artist* dbArtist;

@property (strong, nonatomic) DBManager* db;

@property (strong, nonatomic) IBOutlet UILabel *artistName;
@property (strong, nonatomic) IBOutlet UIImageView *artistImage;
@property (strong, nonatomic) IBOutlet UILabel *nbFans;
@property (strong, nonatomic) IBOutlet UILabel *nbAlbums;

@property (strong, nonatomic) IBOutlet UISwitch *onOfFavorisSwitch;

@end
