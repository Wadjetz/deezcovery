//
//  Track+JsonSerializer.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 22/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Track.h"
#import "DBManager.h"

@interface Track (JsonSerializer)

+ (Track *)trackFromJson:(NSDictionary *)json;

@end
