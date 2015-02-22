//
//  ArtistTrackController.m
//  Deezcovery
//
//  Created by Vuzi on 29/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistTrackController.h"

@interface ArtistTrackController()

@property AVAudioPlayer *player;
@property long playingTrack;

@end

@implementation ArtistTrackController

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    NSDictionary *track = self.tracks[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@)", track[@"title"], track[@"album"][@"title"]];
        
    return cell;
}

// -- Number of sections in the table view --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// -- Number of cells --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.tracks)
        return [self.tracks count];
    else
        return 0;
}

// -- If the cell is editable --
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// -- If the order can be changed --
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// -- Cell selected --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.playingTrack == indexPath.row) {
        if(self.player.playing) {
            [self.player stop];
            NSLog(@"Stopping music");
        } else {
            [self.player play];
            NSLog(@"Resuming music");
        }
    } else {
        self.playingTrack = indexPath.row;
    
        // Stop the old player
        if(self.player) {
            [self.player stop];
        }
    
        // Create a newe player
        NSURL *url = [[NSURL alloc] initWithString:self.tracks[indexPath.row][@"preview"]];
        NSData *sound = [NSData dataWithContentsOfURL:url];
        
        self.player = [[AVAudioPlayer alloc] initWithData:sound error:nil];
        //self.player.delegate = self;
    
        [self.player play];
        NSLog(@"Starting playing music");
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingTrack = -1;
    
    // Artist's tracks
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[DeezerService getTracksLink:self.artist.artist_id]]];
        
        if(data) {
            // Fill the artists list with the results
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([results objectForKey:@"data"]) {
                self.tracks = (NSArray*)results[@"data"];
            } else {
                self.tracks = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view reloadData];
            });
        } else {
            NSLog(@"Error loading tracks");
        }
    });
    
}

@end
