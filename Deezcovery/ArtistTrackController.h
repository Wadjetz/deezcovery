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

@interface ArtistTrackController : UITableViewController <AVAudioPlayerDelegate>

@property (strong, nonatomic) Artist* artist;
@property (strong, nonatomic) NSArray* tracks;
@property (strong, nonatomic) IBOutlet UITableView *view;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

@end
