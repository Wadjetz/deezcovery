//
//  FavorisController.m
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "FavorisController.h"

@implementation FavorisController

- (void)viewDidLoad {
    
    NSLog(@"Hello from favoris");
    self.db = [DBManager sharedInstance];

    self.favoris = [self.db fetchArtists];
    for (Artist *a in self.favoris) {
        NSLog(@"Into DB %@", a.name);
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
