//
//  HGChild.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChild.h"
#import "NSDictionary+Utility.h"

@implementation HGChild

@dynamic childID;
@dynamic name;
@dynamic description;
@dynamic imageThumbnail;
@dynamic imageFull;
@dynamic media;


// Add a child entity to the managed object context and populate it with data from a JSON dictionary.
+ (HGChild *)addChildFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context {
    HGChild *child = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    child.childID = @([[data objectForKeyNotNull:@"id"] integerValue]);
    child.description = [data objectForKeyNotNull:@"description"];
    child.name = [data objectForKeyNotNull:@"name"];
    child.imageThumbnail = [data objectForKeyNotNull:@"image_small"];
    child.imageFull = [data objectForKeyNotNull:@"image_large"];
    return child;
}

@end
