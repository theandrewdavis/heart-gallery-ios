//
//  HGManagedObjectContext.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGManagedObjectContext.h"
#import "Child.h"

#define kCoreDataStoreName @"HGCoreDataStore.sqlite"

@interface HGManagedObjectContext ()

+ (NSManagedObjectModel *)createManagedObjectModel;
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator:(NSManagedObjectModel *)managedObjectModel storeName:(NSString *)storeName;
+ (NSAttributeDescription *)createAttributeDescription:(NSString *)name type:(NSAttributeType)type optional:(BOOL)optional indexed:(BOOL)indexed;

@end

@implementation HGManagedObjectContext

- (id)init {
    self = [super init];
    if (self) {
        NSManagedObjectModel *managedObjectModel = [[self class] createManagedObjectModel];
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[self class] createPersistentStoreCoordinator:managedObjectModel storeName:kCoreDataStoreName];
        self.persistentStoreCoordinator = persistentStoreCoordinator;
    }
    return self;
}

// Create a persistent store coordinator backed with sqlite. If the store cannot be added, attempt to delete the sqlite file before trying again.
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator:(NSManagedObjectModel *)managedObjectModel storeName:(NSString *)storeName {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    // Find the path for the sqlite file in the application's documents directory.
    NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDir URLByAppendingPathComponent:storeName];
    
    // Try to add the sqlite store.
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //  If it fails, try deleting the sqlite file. If it still fails, just log the error.
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Error creating store: %@, %@", error, error.userInfo);
		}
    }
    return persistentStoreCoordinator;
}

// Create the managed object model: a Child entity with attributes such as id, name, and imageThumbnail.
+ (NSManagedObjectModel *)createManagedObjectModel {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] init];
    
    // Create the attribute descriptions for the child entity description.
    NSAttributeDescription *idDescription = [[self class] createAttributeDescription:@"childID" type:NSInteger32AttributeType optional:NO indexed:YES];
    NSAttributeDescription *nameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:YES];
    NSAttributeDescription *descriptionDescription = [[self class] createAttributeDescription:@"description" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *thumbnailDescription = [[self class] createAttributeDescription:@"imageThumbnail" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *imageDescription = [[self class] createAttributeDescription:@"imageFull" type:NSStringAttributeType optional:YES indexed:NO];
    
    // Create the child entity description and add it to the managed object context.
    NSEntityDescription *childEntity = [[NSEntityDescription alloc] init];
    childEntity.name = [Child entityName];
    childEntity.properties = @[idDescription, nameDescription, descriptionDescription, thumbnailDescription, imageDescription];
    managedObjectModel.entities = @[childEntity];
    
    return managedObjectModel;
}

// Convenience method for creating attribute descriptions.
+ (NSAttributeDescription *)createAttributeDescription:(NSString *)name type:(NSAttributeType)type optional:(BOOL)optional indexed:(BOOL)indexed {
    NSAttributeDescription *attributeDescription = [[NSAttributeDescription alloc] init];
    attributeDescription.name = name;
    attributeDescription.attributeType = type;
    attributeDescription.optional = optional;
    attributeDescription.indexed = indexed;
    return attributeDescription;
}

@end
