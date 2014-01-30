//
//  HGManagedObjectContext.h
//  HeartGallery
//
//  Created by Andrew Davis on 1/29/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGManagedObjectContext : NSObject
+ (NSManagedObjectContext *)sharedContext;
+ (void)updateEvents:(NSArray *)events;
+ (NSFetchedResultsController *)createEventResultsController;
@end
