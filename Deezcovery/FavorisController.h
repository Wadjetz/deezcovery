//
//  FavorisController.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Artist.h"

@interface FavorisController : UITableViewController

@property (strong, nonatomic) DBManager* db;
@property (strong, nonatomic) NSArray* favoris;
@property (strong, nonatomic) IBOutlet UITableView *view;

@end
