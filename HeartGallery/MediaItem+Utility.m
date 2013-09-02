//
//  MediaItem+Utility.m
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "MediaItem+Utility.h"
#import "NSDictionary+Utility.h"

@implementation MediaItem (Utility)

// Add a media item entity to the managed object context and populate it with data from a JSON dictionary.
+ (MediaItem *)addMediaItemFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context {
    MediaItem *mediaItem = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    mediaItem.url = [data objectForKeyNotNull:@"url"];
    mediaItem.type = [data objectForKeyNotNull:@"type"];
    return mediaItem;
}

@end
