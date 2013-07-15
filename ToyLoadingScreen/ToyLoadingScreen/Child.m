//
//  Child.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Child.h"

@interface Child ()

+ (void)insertFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)managedObjectContext;
+ (id)nullToNil:(id)object;

@end

@implementation Child

@dynamic childID;
@dynamic name;
@dynamic description;
@dynamic imageThumbnail;
@dynamic imageFull;


// The name of the Child entity used by Core Data.
+ (NSString *)entityName {
    return @"Child";
}

// Clear all children in the store and replace them with the children in the given JSON object.
+ (void)replaceAllFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)managedObjectContext {
    // Create a fetch request for all children.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
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
    for (NSDictionary *newChild in dictionary[@"children"]) {
        [self insertFromDictionary:newChild inContext:managedObjectContext];
    }
    
    // Save the new context.
    NSError *saveError = nil;
    if (![managedObjectContext save:&saveError]) {
        NSLog(@"Error saving store: %@, %@", saveError, saveError.userInfo);
    }
}

// Map the attributes used in the JSON object to the values used in the Core Data store.
+ (void)insertFromDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)managedObjectContext {
    Child *child = [NSEntityDescription insertNewObjectForEntityForName:self.entityName inManagedObjectContext:managedObjectContext];
    child.childID = @([dictionary[@"id"] integerValue]);
    child.description = [self nullToNil:dictionary[@"description"]];
    child.name = [self nullToNil:dictionary[@"name"]];
    child.imageThumbnail = [self nullToNil:dictionary[@"image_small"]];
    child.imageFull = [self nullToNil:dictionary[@"image_large"]];
}

// Core Data does not accept NSNull values, so replace instances of NSNull with nil.
+ (id)nullToNil:(id)object {
    return ([object isEqual:[NSNull null]]) ? nil : object;
}

@end
