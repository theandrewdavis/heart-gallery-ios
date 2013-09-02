//
//  Version+Utility.m
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Version+Utility.h"
#import "NSDictionary+Utility.h"

@implementation Version (Utility)

// Add a media item entity to the managed object context and populate it with data from a JSON dictionary.
+ (Version *)addVersion:(NSString *)value toContext:(NSManagedObjectContext *)context {
    Version *version = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    version.value = value;
    return version;
}

@end
