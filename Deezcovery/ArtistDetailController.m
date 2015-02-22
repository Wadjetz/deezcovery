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
- (IBAction)onOfFavorisSwitch:(id)sender {
    
    self.dbArtist = [self.db getArtist:self.artist.artist_id];
    
    if(self.onOfFavorisSwitch.on) {
        NSLog(@"on");
        // Artist's tracks
        
        if (self.dbArtist == nil) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[DeezerService getTracksLink:self.artist.artist_id]]];
                
                if(data) {
                    // Fill the artists list with the results
                    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                    if([results objectForKey:@"data"]) {
                        NSArray *jsonTracks = (NSArray*)results[@"data"];
                        NSMutableArray * tracks = [@[] mutableCopy];
                        for (id item in jsonTracks) {
                            Track * track = [Track trackFromJson:item];
                            [tracks addObject:track];
                            
                        }
                        
                        NSLog(@"ITEM == %@", tracks);
                    } else {
                        NSLog(@"No Traks");
                    }
                } else {
                    NSLog(@"Error loading tracks");
                }
            });
            
            [self.db saveArtist:self.artist];
        }
    } else {
        NSLog(@"of");
        NSLog(@"Delete Favoris");
        self.dbArtist = [self.db getArtist:self.artist.artist_id];
        if (self.dbArtist != nil) {
            [self.db deleteManagedObject:self.dbArtist];
            [self.db persistData];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [DBManager sharedInstance];
    
    [self.db getTracks:self.artist];
    
    self.dbArtist = [self.db getArtist:self.artist.artist_id];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)showTrackList:(id)sender {
    [self performSegueWithIdentifier:@"showTracklist" sender:self.artist];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showTracklist"]) {
        ArtistTrackController *controller = segue.destinationViewController;
        controller.artist = sender;
    }
}

@end
