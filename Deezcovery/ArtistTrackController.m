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

    static int index =  0;

    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    Track *track = self.tracks[indexPath.row];

    // Configure cell
    //cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@)", track[@"title"], track[@"album"][@"title"]];
    cell.imageView.image = [UIImage imageNamed:@"play"];
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@)", track.title, track.album_title];

    if(++index % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];

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

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(self.playingTrack == indexPath.row) {
        if(self.player.playing) {
            [self.player stop];
            NSLog(@"Stopping music");
            
            cell.imageView.image = [UIImage imageNamed:@"play"];
        } else {
            [self.player play];
            NSLog(@"Resuming music");
            cell.imageView.image = [UIImage imageNamed:@"pause"];
        }
    } else {

        // Get the previous cell
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:self.playingTrack inSection:0]];
        if(oldCell) {
            oldCell.imageView.image = [UIImage imageNamed:@"play"];
        }

        // Prepare the new cell
        self.playingTrack = indexPath.row;
        cell.imageView.image = [UIImage imageNamed:@"loading"];

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
                    self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
                    self.player.delegate = self;
                    [self.player play];
                    NSLog(@"Starting playing music");
                    cell.imageView.image = [UIImage imageNamed:@"pause"];
                });
            } else {
                NSLog(@"Error loading data");
            }
        });
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingTrack = -1;
    self.db = [DBManager sharedInstance];
    self.dbArtist = [self.db getArtist:self.artist.artist_id];
    
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
                        NSLog(@"%@", track.title);
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

// -- Called when the player ends the music --
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow:self.playingTrack inSection:0]];
    self.playingTrack = -1;
    if(oldCell) {
        oldCell.imageView.image = [UIImage imageNamed:@"play"];
    }
    NSLog(@"Music ended");
}

@end
