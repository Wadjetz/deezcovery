//
//  Artist+JsonSerializer.h
//  Deezcovery
//
//  Created by Egor Berezovskiy on 21/02/15.
//  Copyright (c) 2015 ESGIAL1-2014. All rights reserved.
//

#import "Artist.h"
#import "DBManager.h"

@interface Artist (JsonSerializer)

// -- Deserialise an artist from JSON --
+ (Artist *)artistFromJson:(NSDictionary *)json;

@end
