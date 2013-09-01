//
//  HGVersion.h
//  HeartGallery
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HGVersion : NSManagedObject
@property (nonatomic, strong) NSString *value;
+ (HGVersion *)addVersion:(NSString *)value toContext:(NSManagedObjectContext *)context;
@end
