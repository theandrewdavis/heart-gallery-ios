//
//  Child.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Child : NSManagedObject

@property (nonatomic, retain) NSNumber* childID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;
@property (nonatomic, retain) NSString* imageThumbnail;
@property (nonatomic, retain) NSString* imageFull;

+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext;
+ (void)replaceAllWith:(NSArray *)newChildren inContext:(NSManagedObjectContext *)managedObjectContext;

@end
