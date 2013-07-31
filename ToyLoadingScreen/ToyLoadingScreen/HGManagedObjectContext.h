//
//  HGManagedObjectContext.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HGManagedObjectContext : NSManagedObjectContext

- (void)replaceWithDictionary:(NSDictionary *)dictionary;

@end
