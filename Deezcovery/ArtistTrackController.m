//
//  ArtistTrackController.m
//  Deezcovery
//
//  Created by Vuzi on 29/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistTrackController.h"
#import "CustomTrackCell.h"
#define CUSTOM_TRACK_CELL  @"customTrackCell"


@interface ArtistTrackController()

@property AVAudioPlayer *player; // Audio player
@property long playingTrack;     // Number of the track currently playing
@property long allPlayingTrack;
@property BOOL playAll;

@end

@implementation ArtistTrackController

// -- View of a cell --
- (CustomTrackCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static int index =  0;

    // Create a new cell
    CustomTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:CUSTOM_TRACK_CELL];
    
    if (cell == nil) {
        //cell = [[CustomTrackCell alloc] init]; // or your custom initialization
        cell = [[CustomTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CUSTOM_TRACK_CELL];
    }
    
    
    
    Track *track = self.tracks[indexPath.row];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:track.image]];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [cell.customTrackImage setImage:[[UIImage alloc] initWithData:data scale:2.0]];
    });

    // Configure cell
    //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@)", track[@"title"], track[@"album"][@"title"]];
    cell.customImageControl.image = [UIImage imageNamed:@"play"];
    cell.customTitle.text = track.title;
    cell.customInfo.text = track.album_title;
    

    if(++index % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(CustomTrackCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    Track * track = [self.tracks objectAtIndex:indexPath.row];
    cell.customTitle.text = track.title;
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
    CustomTrackCell *cell = (CustomTrackCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.allPlayingTrack = indexPath.row;
    if(self.playingTrack == indexPath.row) {
        if(self.player.playing) {
            [self.player stop];
            NSLog(@"Stopping music");
            
            cell.customImageControl.image = [UIImage imageNamed:@"play"];
        } else {
            [self.player play];
            NSLog(@"Resuming music");
            cell.customImageControl.image = [UIImage imageNamed:@"pause"];
        }
    } else {

        // Get the previous cell
        CustomTrackCell *oldCell = (CustomTrackCell*)[tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:self.playingTrack inSection:0]];
        if(oldCell) {
            oldCell.customImageControl.image = [UIImage imageNamed:@"play"];
        }

        // Prepare the new cell
        self.playingTrack = indexPath.row;
        cell.customImageControl.image = [UIImage imageNamed:@"loading"];

        // Stop the old player
        if(self.player) {
            [self.player stop];
        }

        // Load the track
        NSLog(@"Loading music");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = nil;
            Track * track = self.tracks[indexPath.row];
            if (self.offline == YES) {
                data = track.preview_data;
            } else {
                NSURL *url = [[NSURL alloc] initWithString:track.preview];
                data = [[NSData alloc] initWithContentsOfURL:url];
            }
            
            if(data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Create a new player
                    [self play:data];
                    NSLog(@"Starting playing music");
                    cell.customImageControl.image = [UIImage imageNamed:@"pause"];
                });
            } else {
                NSLog(@"Error loading data");
            }
        });
    }
}

// -- Called on load --
- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingTrack = -1;
    self.db = [DBManager sharedInstance];
    self.dbArtist = [self.db getArtist:self.artist.artist_id];
    self.allPlayingTrack = 0;
    self.playAll = NO;
    
    if (self.dbArtist == nil) {
        self.offline = NO;
        // Artist's tracks
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[DeezerService getTracksLink:self.artist.artist_id]]];
            
            if(data) {
                // Fill the artists list with the results
                NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if([results objectForKey:@"data"]) {
                    NSArray *jsonTracks = (NSArray*)results[@"data"];
                    NSMutableArray * tracksTmp = [@[] mutableCopy];
                    for (id item in jsonTracks) {
                        Track * track = [Track trackFromJson:item];
                        [tracksTmp addObject:track];
                        NSLog(@"%@", item);
                    }
                    self.tracks = [NSArray arrayWithArray:tracksTmp];
                } else {
                    self.offline = YES;
                    self.tracks = [self.db getTracks:self.artist];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view reloadData];
                });
            } else {
                NSLog(@"Error loading tracks");
            }
        });
    } else {
        self.offline = YES;
        self.tracks = [self.db getTracks:self.dbArtist];
    }
    NSLog(@"offline = %d", self.offline);
}

- (IBAction)playAllTracks:(id)sender {
    if(self.playAllSwitch.on) {
        self.playAll = YES;
        [self startPlayAll];
    } else {
        self.playAll = NO;
        [self stopPlayAll];
    }
}


- (void)startPlayAll {
    NSLog(@"startPlayAll track=%li play=%d tracksTotal=%lu", self.allPlayingTrack, self.playAll, (unsigned long)self.tracks.count);
    if (self.allPlayingTrack > (self.tracks.count - 1)) {
        NSLog(@"Reset");
        self.allPlayingTrack = 0;
    }
    
    NSLog(@"startPlayAll track=%li paly=%d", self.allPlayingTrack, self.playAll);
    if (self.playAll == YES) {
        
        NSLog(@"GO");
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.allPlayingTrack inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
        
    }
}

- (void)stopPlayAll {
    if(self.player.playing) {
        [self.player stop];
    }
}

- (void)play:(NSData *)data {
    NSLog(@"PLAY");
    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
    self.player.delegate = self;
    [self.player play];
}

// -- Called when the player ends the music --
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    CustomTrackCell *oldCell = (CustomTrackCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:self.playingTrack inSection:0]];
    self.playingTrack = -1;
    if(oldCell) {
        oldCell.customImageControl.image = [UIImage imageNamed:@"play"];
    }
    self.allPlayingTrack++;
    [self startPlayAll];
    NSLog(@"Music ended");
}

@end
