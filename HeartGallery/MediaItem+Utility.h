//
//  MediaItem+Utility.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "MediaItem.h"

@interface MediaItem (Utility)
+ (MediaItem *)addMediaItemFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context;
@end
