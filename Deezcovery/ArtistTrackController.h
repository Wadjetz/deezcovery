//
//  ArtistTrackController.h
//  Deezcovery
//
//  Created by Vuzi on 29/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Artist.h"

@interface ArtistTrackController : UITableViewController

@property (strong, nonatomic) Artist* artist;
@property (strong, nonatomic) NSArray* tracks;
@property (strong, nonatomic) IBOutlet UITableView *view;

@end
