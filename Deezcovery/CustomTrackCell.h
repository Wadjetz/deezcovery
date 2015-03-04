//
//  CustomTrackCell.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 04/03/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTrackCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *customTitle;
@property (strong, nonatomic) IBOutlet UILabel *customInfo;
@property (strong, nonatomic) IBOutlet UIImageView *customImageControl;
@property (strong, nonatomic) IBOutlet UIImageView *customTrackImage;
@property (strong, nonatomic) IBOutlet UIProgressView *customProgressBar;


@end
