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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Artist's infos
    self.artistName.text = self.artist.name;
    self.nbFans.text = [[NSString alloc] initWithFormat:@"%i", self.artist.nb_fan];
    self.nbAlbums.text = [[NSString alloc] initWithFormat:@"%i", self.artist.nb_album];
    
    // Artist's image
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.artist getPhotoLink]]];
        
        if(data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.artistImage setImage:[[UIImage alloc] initWithData:data scale:2.0]];
            });
        } else {
            NSLog(@"Error loading image");
        }
    });
    NSLog(@"hello");
    NSLog(@"hello");
    NSLog(@"hello");
    NSLog(@"hello");
    NSLog(@"hello");
    NSLog(@"hello");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)showTrackList:(id)sender {
    NSLog(@"hello");
    [self performSegueWithIdentifier:@"showTracklist" sender:self.artist];
}
- (IBAction)dfgbndfgsn:(id)sender {
    NSLog(@"hello");
    [self performSegueWithIdentifier:@"showTracklist" sender:self.artist];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showTracklist"]) {
        ArtistTrackController *controller = segue.destinationViewController;
        controller.artist = sender;
    }
}
- (IBAction)test:(id)sender {
    NSLog(@"hello");
}

@end
