//
//  ArtistDetailController.m
//  Deezcovery
//
//  Created by Vuzi on 28/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistDetailController.h"

@implementation ArtistDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Artist's infos
    self.artistName.text = self.artist.name;
    self.nbFans.text = [[NSString alloc] initWithFormat:@"%i", self.artist.nb_fan];
    self.nbAlbums.text = [[NSString alloc] initWithFormat:@"%i", self.artist.nb_album];
    
    // Artist's image
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[self.artist getPhotoLink]]];
    
    NSOperationQueue *queue =[[NSOperationQueue alloc] init];
    
    // The block called
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // If no errors
        if(!connectionError) {
            [self.artistImage setImage:[[UIImage alloc] initWithData:data scale:2.0]];
            
            [self.artistImage setNeedsDisplay];
            [self.artistImage reloadInputViews];
             
            NSLog(@"Image loaded");
        } else {
            NSLog(@"Error : %@", connectionError);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
