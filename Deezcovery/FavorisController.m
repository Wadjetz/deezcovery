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

@property (strong, nonatomic) DBManager* db;
@property (strong, nonatomic) NSMutableArray* favoris;
@property (strong, nonatomic) Artist* selectedArtist;

@end


@implementation FavorisController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Hello from favoris");
    self.db = [DBManager sharedInstance];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.favoris = [[self.db fetchArtists] mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"FavorisController viewWillAppear");
    [super viewWillAppear:animated];
    self.favoris = [[self.db fetchArtists] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// -- Cell selected --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Fuck IOS - didSelectRowAtIndexPath");
    self.selectedArtist = self.favoris[indexPath.row];
    [self performSegueWithIdentifier:SEGUE_TO_DETAIL_ID sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    NSLog(@"Fuck IOS - prepareForSegue");
    if([segue.identifier isEqualToString:SEGUE_TO_DETAIL_ID]) {
        ArtistDetailController *controller = segue.destinationViewController;
        controller.artist = self.selectedArtist;
        NSLog(@"Fuck IOS - prepareForSegue controller.artist = %@", self.selectedArtist);
    }
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a new cell
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ARTIST_FAVORIS_CELL_ID];
    
    Artist *artist = self.favoris[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = artist.name;
    
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
