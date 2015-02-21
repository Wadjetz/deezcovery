//
//  ArtistSearchController.m
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import "ArtistSearchController.h"
#import "Artist.h"
#import "DeezerService.h"
#import "Artist+JsonSerializer.h"
#import "ArtistDetailController.h"

@interface ArtistSearchController ()

@property (nonatomic, strong)UISearchDisplayController *searchController;
@property (strong)NSMutableArray *artistsList;
@property (strong)UITableView *resultsView;

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
    self.artistsList = [[NSMutableArray alloc] init];
    
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
    
    if(self.artistsList)
        return [self.artistsList count];
    else
        return 0;
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    Artist* artist = self.artistsList[indexPath.row];
    
    if(indexPath.row > 0)
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@ fans)", artist.name, artist.nb_fan];
    else {
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"Similar to %@ :", artist.name];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
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

// -- Cell selected --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showArtist" sender:self.artistsList[indexPath.row]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showArtist"]) {
        ArtistDetailController *controller = segue.destinationViewController;
        NSLog(@"%@", sender);
        controller.artist = sender;
    }
}

#pragma mark Search Display Delegate Methods

-(void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView {
    self.resultsView = tableView;
}

-(void)searchArtist:(NSString*) artistName {
    
}

-(void)searchSimilarArtist:(NSDictionary*) artist {
    
    // The URL request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/artist/%@/related", DEEZER_ENDPOINT, artist[@"id"]]]];
    
    // The block called
    [NSURLConnection sendAsynchronousRequest:request queue:self.queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // If no errors
        if(!connectionError) {
            // Get the first artist (if any)
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([results objectForKey:@"data"]) {
                if([self.artistsList count] > 0)
                    [self.artistsList removeAllObjects];
                
                [self.artistsList addObject:[Artist artistFromJson:artist]];
                for(int i = 0; i < [results[@"data"] count]; i++)
                    [self.artistsList addObject:[Artist artistFromJson:[results[@"data"] objectAtIndex:i]]];
                
                [self reloadResults];
            }
        } else {
            // Error, empty and log
            [self.artistsList removeAllObjects];
            NSLog(@"Error : %@", connectionError);
        }
    }];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    // Cancel all the pending searchs
    [self.queue cancelAllOperations];
    
    // Nothing to search
    if(self.searchBar.text.length <= 0) {
        [self.artistsList removeAllObjects];
        
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
            // Get the first artist (if any)
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if([results objectForKey:@"data"]) {
                
                // If any artist
                NSArray *data = [results objectForKey:@"data"];
                if(data.count > 0)  {
                    // Get similar artists
                    [self searchSimilarArtist:data[0]];
                }
            }
        } else {
            // Error, empty and log
            [self.artistsList removeAllObjects];
            NSLog(@"Error : %@", connectionError);
        }
    }];
    
    return YES;
}

-(void) reloadResults {
    if(self.resultsView)
        [self.resultsView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}


@end
