//
//  HGVersion.m
//  HeartGallery
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGVersion.h"

@implementation HGVersion

@dynamic value;
@dynamic date;

// Add a media item entity to the managed object context and populate it with data from a JSON dictionary.
+ (HGVersion *)addVersion:(NSString *)value toContext:(NSManagedObjectContext *)context {
    HGVersion *version = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    version.value = value;
    version.date = [NSDate date];
    return version;
}

@end
