//
//  ArtistDetailController.m
//  Deezcovery
//
//  Created by Vuzi on 28/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistDetailController.h"
#import "ArtistTrackController.h"

@implementation ArtistDetailController

// -- On favorite switch action --
- (IBAction)onOfFavorisSwitch:(id)sender {
    NSLog(@"dbArtist = %@", self.dbArtist.artist_id);
    NSLog(@"artist = %@", self.artist.artist_id);
    
    if(self.onOfFavorisSwitch.on) {
        NSLog(@"on");
        // Artist's tracks
        [self.db saveArtist:self.currentArtistId
                       with:self.currentArtistName
                       with:self.currentArtistNbAlbums
                       with:self.currentArtistNbFan];
        
        if (self.dbArtist == nil) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[DeezerService getTracksLink:self.artist.artist_id]]];
                
                if(data) {
                    // Fill the artists list with the results
                    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if([results objectForKey:@"data"]) {
                        NSArray *jsonTracks = (NSArray*)results[@"data"];
                        for (id item in jsonTracks) {
                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                Track * track = [Track trackFromJson:item];
                                NSURL *url = [[NSURL alloc] initWithString:track.preview];
                                track.preview_data = [[NSData alloc] initWithContentsOfURL:url];
                                [self.db saveTrack:track forArtist:self.artist];
                            });
                        }
                    } else {
                        NSLog(@"No Traks");
                    }
                } else {
                    NSLog(@"Error loading tracks");
                }
            });
        }
    } else {
        NSLog(@"Delete Favoris");
        self.dbArtist = [self.db getArtist:self.currentArtistId];
        NSArray * tracks = [self.db getTracks:self.dbArtist];
        if (self.dbArtist != nil) {
            [self.db deleteManagedObject:self.dbArtist];
            for (id track in tracks) {
                [self.db deleteManagedObject:track];
            }
            [self.db persistData];
        }
    }
}

// -- Call on load --
- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [DBManager sharedInstance];
    
    //NSLog(@"getTracks ==> %@", [self.db getTracks:self.artist]);
    
    self.dbArtist = [self.db getArtist:self.artist.artist_id];
    
    self.currentArtistId = self.artist.artist_id.copy;
    self.currentArtistName = self.artist.name.copy;
    self.currentArtistNbAlbums = self.artist.nb_album.copy;
    self.currentArtistNbFan = self.artist.nb_fan.copy;
    
    if(self.dbArtist == nil) {
        self.onOfFavorisSwitch.on = NO;
    } else {
        self.onOfFavorisSwitch.on = YES;
    }

    // Artist's infos
    self.artistName.text = self.artist.name;
    self.nbFans.text = [[NSString alloc] initWithFormat:@"%@", self.artist.nb_fan];
    self.nbAlbums.text = [[NSString alloc] initWithFormat:@"%@", self.artist.nb_album];
    
    // Artist's image
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[DeezerService getPhotoLink:self.artist.artist_id]]];
        
        if(data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.artistImage setImage:[[UIImage alloc] initWithData:data scale:2.0]];
            });
        } else {
            NSLog(@"Error loading image");
        }
    });
    
}

// -- Memory warning --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// -- Segue to show tracks --
- (IBAction)showTrackList:(id)sender {
    [self performSegueWithIdentifier:@"showTracklist" sender:self.artist];
}

// -- Prepare to perform segue --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showTracklist"]) {
        ArtistTrackController *controller = segue.destinationViewController;
        controller.artist = sender;
    }
}

@end
