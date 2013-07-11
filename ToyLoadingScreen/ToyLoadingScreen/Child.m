//
//  Child.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Child.h"

@implementation Child

@dynamic id;
@dynamic name;
@dynamic imageThumbnail;
@dynamic imageFull;

// Get all Child objects in the given managed object context, sorted by name.
+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext {
    // Create a fetch request for all children sorted by name.
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortNameDescending = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[sortNameDescending];
    
    // Execute the fetch request and log errors.
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"Error fetching from store: %@, %@", error, error.userInfo);
    }
    return results;
}

@end
