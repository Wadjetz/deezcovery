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

- (IBAction)addFavoris:(id)sender {
    NSLog(@"Save = %@", self.artist);
    
    Artist * newArtist = [self.db createManagedObjectWithClass:[Artist class]];
    newArtist.artist_id = self.artist.artist_id;
    newArtist.name = self.artist.name;
    newArtist.nb_album = self.artist.nb_album;
    newArtist.nb_fan= self.artist.nb_fan;
    
    [self.db persistData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.db = [DBManager sharedInstance];
    NSArray* list = [self.db fetchArtists];
    for (Artist *a in list) {
        NSLog(@"Into DB %@", a.name);
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
