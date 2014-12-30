//
//  ArtistTrackController.m
//  Deezcovery
//
//  Created by Vuzi on 29/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistTrackController.h"

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

- (void)viewDidLoad {
    
    // Artist's tracks
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self.artist getTracksLink]]];
        
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
