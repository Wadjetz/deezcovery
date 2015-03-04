//
//  ArtistSearchController.h
//  Deezcovery
//
//  Created by Vuzi on 27/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistSearchController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar; // Search bar used in the view
@property (strong, nonatomic) IBOutlet UITableView *tableView; // Table view used to display the results

@end
