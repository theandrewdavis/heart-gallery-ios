//
//  Version+Utility.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Version.h"

@interface Version (Utility)
+ (Version *)addVersion:(NSString *)value toContext:(NSManagedObjectContext *)context;
@end
