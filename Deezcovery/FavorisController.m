//
//  FavorisController.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "FavorisController.h"

#define ARTIST_FAVORIS_CELL_ID     @"ArtistFavorisCellId"
#define SEGUE_TO_DETAIL_ID         @"showFavorisArtist"

@interface FavorisController()

@property (strong, nonatomic) DBManager* db;           // Database manager
@property (strong, nonatomic) NSMutableArray* favoris; // Favorites list
@property (strong, nonatomic) Artist* selectedArtist;  // Selected artist

@end


@implementation FavorisController

// -- Call on load --
- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [DBManager sharedInstance];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.favoris = [[self.db fetchArtists] mutableCopy];
}

// -- Call before the view appears --
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.favoris = [[self.db fetchArtists] mutableCopy];
    [self.tableView reloadData];
}

// -- Memory warning --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// -- Cell selected --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedArtist = self.favoris[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_TO_DETAIL_ID sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:SEGUE_TO_DETAIL_ID]) {
        ArtistDetailController *controller = segue.destinationViewController;
        controller.artist = self.selectedArtist;
    }
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static int index;
    
    // Create a new cell
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ARTIST_FAVORIS_CELL_ID];
    
    Artist *artist = self.favoris[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = artist.name;
    if(++index % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
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
    return self.favoris.count;
}

@end
