//
//  ArtistSearchController.m
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistSearchController.h"
#import "Artist.h"
#import "ArtistList.h"

@interface ArtistSearchController ()

@property (nonatomic, strong)UISearchDisplayController *searchController;
@property (strong)ArtistList *artistsList;

@property NSOperationQueue *queue;

@end

@implementation ArtistSearchController

static NSString *CellIdentifier = @"CellIdentifier";

// -- At the view load --
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup controller
    self.searchController = [[UISearchDisplayController alloc] init];
    self.searchController.searchResultsDataSource = self;
    
    // Init model
    self.artistsList = [[ArtistList alloc] init];
    
    // The event queue
    self.queue = [[NSOperationQueue alloc] init];
}

// -- Memory warning --
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// -- Number of sections in the table view --
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// -- Number of cells --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"size asked : %lu", (unsigned long)[self.artistsList.artists count]);
    
    if(self.artistsList.artists)
        return [self.artistsList.artists count];
    else
        return 0;
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    Artist* artist = self.artistsList.artists[indexPath.row];
    
    // Configure cell
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%i fans)", artist.name, artist.nb_fan];
    
    NSLog(@"Called refresh");
    
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

#pragma mark Search Display Delegate Methods

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    NSLog(@"Called with : %@",  self.searchBar.text);
    
    // Cancel all the pending searchs
    [self.queue cancelAllOperations];
    
    // Nothing to search
    if(self.searchBar.text.length <= 0) {
        [self.artistsList.artists removeAllObjects];
        
        // Reload
        [self reloadResults];
        
        return TRUE;
    }
    
    // The URL request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/search/artist?q=%@", DEEZER_ENDPOINT, [self.searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]]];
    
    // The block called
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // If no errors
        if(!connectionError) {
            // Fill the artists list with the results
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([results objectForKey:@"data"]) {
                [self.artistsList fillWithArray:(NSArray*)results[@"data"]];
            }
        } else {
            // Error, empty and log
            [self.artistsList.artists removeAllObjects];
            NSLog(@"Error : %@", connectionError);
        }
        
        [self reloadResults];
    }];
    
    return YES;
}

-(void) reloadResults {
    [self.searchController.searchResultsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


@end
