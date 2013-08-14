//
//  HGChild.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChild.h"
#import "NSDictionary+Utility.h"

static NSString *kThumbnailUrlPrefix = @"http://www.heartgalleryalabama.com/images/children/thumbs/primary/";

@implementation HGChild

@dynamic name;
@dynamic description;
@dynamic gender;
@dynamic birthday;
@dynamic thumbnail;
@dynamic media;


// Add a child entity to the managed object context and populate it with data from a JSON dictionary.
+ (HGChild *)addChildFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
    }

    HGChild *child = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    child.name = [data objectForKeyNotNull:@"name"];
    child.description = [data objectForKeyNotNull:@"description"];
    child.gender = [data objectForKeyNotNull:@"gender"];
    child.birthday = [dateFormatter dateFromString:[data objectForKeyNotNull:@"birthday"]];
    child.thumbnail = [data objectForKeyNotNull:@"thumbnail"];
    return child;
}

// Return the full URL for an thumbnail.
- (NSURL *)thumbnailURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kThumbnailUrlPrefix, self.thumbnail]];
}

@end
