//
//  FavorisController.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "FavorisController.h"

#define ARTIST_FAVORIS_CELL_ID @"ArtistFavorisCellId"

@interface FavorisController()

@end


@implementation FavorisController

- (void)viewDidLoad {
    
    NSLog(@"Hello from favoris");
    self.db = [DBManager sharedInstance];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.favoris = [self.db fetchArtists];
    for (Artist *a in self.favoris) {
        NSLog(@"Into DB %@", a.name);
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// -- Cell selected --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Select %@", self.favoris[indexPath.row]);
    [self performSegueWithIdentifier:@"showFavorisArtist" sender:self.favoris[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showFavorisArtist"]) {
        ArtistDetailController *controller = segue.destinationViewController;
        controller.artist = sender;
    }
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Artist *artist = self.favoris[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", artist.name];
    
    return cell;
}

// -- If the cell is editable --
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// -- If the order can be changed --
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// -- Number of sections in the table view --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// -- Number of cells --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.favoris)
        return [self.favoris count];
    else
        return 0;
}

@end
