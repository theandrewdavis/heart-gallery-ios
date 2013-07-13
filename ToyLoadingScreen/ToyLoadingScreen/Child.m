//
//  Child.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Child.h"

@implementation Child

@dynamic childID;
@dynamic name;
@dynamic description;
@dynamic imageThumbnail;
@dynamic imageFull;

// Get all Child objects in the given managed object context, sorted by name.
+ (NSArray *)allFromContext:(NSManagedObjectContext *)managedObjectContext {
    // Create a fetch request for all children sorted by name.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Child"];
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

+ (void)replaceAllWith:(NSArray *)newChildren inContext:(NSManagedObjectContext *)managedObjectContext {
    // Create a fetch request for all children.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Child"];
    request.includesPropertyValues = NO;
    
    // Execute the fetch request and log errors.
    NSError *fetchError = nil;
    NSArray *children = [managedObjectContext executeFetchRequest:request error:&fetchError];
    if (fetchError != nil) {
        NSLog(@"Error clearing store: %@, %@", fetchError, fetchError.userInfo);
    }

    // Delete all children from the managed object context.
    for (Child* child in children) {
        [managedObjectContext deleteObject:child];
    }
    
    // Add all children in the new dataset to the managed object context.
    for (NSDictionary *newChild in newChildren) {
        Child *child = [NSEntityDescription insertNewObjectForEntityForName:@"Child" inManagedObjectContext:managedObjectContext];
        child.childID = [NSNumber numberWithInteger:[newChild[@"id"] integerValue]];
        child.description = newChild[@"description"];
        child.name = newChild[@"name"];
        child.imageThumbnail = newChild[@"image_small"];
        child.imageFull = newChild[@"image_large"];
    }
    
    // Save the new context.
    NSError *saveError = nil;
    [managedObjectContext save:&saveError];
    if (saveError != nil) {
        NSLog(@"Error saving store: %@, %@", saveError, saveError.userInfo);
    }
}

@end
