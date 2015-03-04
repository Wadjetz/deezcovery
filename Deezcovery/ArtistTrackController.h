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
#import "Track.h"
#import "Track+JsonSerializer.h"
#import "DeezerService.h"
#import "DBManager.h"

@interface ArtistTrackController : UITableViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) Artist* artist;              // Artist which tracks are displayed
@property (strong, nonatomic) Artist* dbArtist;            // Artist saved
@property (strong, nonatomic) NSArray* tracks;             // List of tracks
@property (strong, nonatomic) IBOutlet UITableView *view;  // Table view used to display the tracks
@property (assign, nonatomic) BOOL offline;

@property (strong, nonatomic) DBManager* db;  // Database manager

// -- Delegate for the audio player --
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
