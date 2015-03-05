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

@property (nonatomic, strong)UISearchController *searchController;
@property (strong)NSMutableArray *artistsList;

@property NSOperationQueue *queue;


@end

@implementation ArtistSearchController

static NSString *CellIdentifier = @"CellIdentifier";

// -- At the view load --
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup delegate
    self.searchBar.delegate = self;
    
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
    
    NSLog(@"View reload");
    
    if(self.artistsList && [self.artistsList count] > 0)
        return [self.artistsList count];
    else
        return 1;
}

// -- View of a cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static int index = 0;
    
    // Create a new cell
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if(indexPath.row > 0) {
        Artist* artist = self.artistsList[indexPath.row];
        cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - (%@ fans)", artist.name, artist.nb_fan];
        if(++index % 2 == 0)
            cell.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    } else {
        index = 0;
        if(self.artistsList && [self.artistsList count] > 0) {
            Artist* artist = self.artistsList[indexPath.row];
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"Similaire à %@ :", artist.name];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
            cell.backgroundColor = [UIColor lightGrayColor];
        } else {
            cell.textLabel.text = @"Aucun résultats";
            cell.textLabel.textColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.9];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
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
    if (self.artistsList.count > 0) {
        [self performSegueWithIdentifier:@"showArtist" sender:self.artistsList[indexPath.row]];
    } else {
        NSLog(@"Recherche vide");
    }
}

// -- Artist detail --
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Prepare the segue, set the sended artist
    if([segue.identifier isEqualToString:@"showArtist"]) {
        ArtistDetailController *controller = segue.destinationViewController;
        controller.artist = sender;
    }
}

// -- Text changed in search bar --
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchArtisteAndSimmilarTo:searchText];
}

// -- Search for a similar artist --
-(void)searchSimilarArtist:(NSDictionary*) artist {
    // The URL request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[DeezerService getArtistsRelated:artist[@"id"]]]];
    
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

// -- Search for an artist and similar artists --
- (void)searchArtisteAndSimmilarTo:(NSString *)searchString {
    NSLog(@"Search request with '%@'", searchString);
    
    // Cancel all the pending searchs
    [self.queue cancelAllOperations];
    
    // Nothing to search
    if(self.searchBar.text.length <= 0) {
        return;
    }
    
    // The URL request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/search/artist?q=%@", DEEZER_ENDPOINT, [searchString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]]]];
    
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
    
}

// -- For the view reload --
-(void) reloadResults {
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

@end
