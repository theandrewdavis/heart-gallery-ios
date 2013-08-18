//
//  HGMediaItem.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/24/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HGMediaItem : NSManagedObject

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;

+ (HGMediaItem *)addMediaItemFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context;

@end
