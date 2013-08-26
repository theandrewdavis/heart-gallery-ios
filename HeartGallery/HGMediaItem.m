//
//  HGMediaItem.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/24/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGMediaItem.h"
#import "NSDictionary+Utility.h"

@implementation HGMediaItem

@dynamic url;
@dynamic type;

// Add a media item entity to the managed object context and populate it with data from a JSON dictionary.
+ (HGMediaItem *)addMediaItemFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context {
    HGMediaItem *mediaItem = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    mediaItem.url = [data objectForKeyNotNull:@"url"];
    mediaItem.type = [data objectForKeyNotNull:@"type"];
    return mediaItem;
}

@end
