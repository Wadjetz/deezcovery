//
//  AppDelegate.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 16/12/14.
//  Copyright (c) 2014 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window; // Main Window
@property (strong, nonatomic) DBManager *db;    // Database manager

@end

