//
//  HGManagedObjectContext.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGManagedObjectContext.h"
#import "HGVersion.h"
#import "HGChild.h"
#import "HGMediaItem.h"

#define kCoreDataStoreName @"HGCoreDataStore.sqlite"

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

// Create the managed object model: a Child entity with attributes such as id, name, and imageThumbnail.
+ (NSManagedObjectModel *)createManagedObjectModel {
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] init];

    // Create the version entity description.
    NSAttributeDescription *versionValueDescription = [[self class] createAttributeDescription:@"value" type:NSStringAttributeType optional:NO indexed:NO];
    NSEntityDescription *versionEntity = [[NSEntityDescription alloc] init];
    versionEntity.name = NSStringFromClass([HGVersion class]);
    
    // Create the child entity description.
    NSAttributeDescription *childIdDescription = [[self class] createAttributeDescription:@"childID" type:NSInteger32AttributeType optional:NO indexed:YES];
    NSAttributeDescription *childNameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:YES];
    NSAttributeDescription *childDescriptionDescription = [[self class] createAttributeDescription:@"description" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *childThumbnailDescription = [[self class] createAttributeDescription:@"imageThumbnail" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *childImageDescription = [[self class] createAttributeDescription:@"imageFull" type:NSStringAttributeType optional:YES indexed:NO];
    NSEntityDescription *childEntity = [[NSEntityDescription alloc] init];
    childEntity.name = NSStringFromClass([HGChild class]);

    // Create the media entity description.
    NSAttributeDescription *mediaNameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:NO];
    NSAttributeDescription *mediaTypeDescription = [[self class] createAttributeDescription:@"type" type:NSInteger32AttributeType optional:NO indexed:YES];
    NSEntityDescription *mediaEntity = [[NSEntityDescription alloc] init];
    mediaEntity.name = NSStringFromClass([HGMediaItem class]);
    
    // Create a one-to-many relationship between a child and its media.
    NSRelationshipDescription *childMediaDescription = [[NSRelationshipDescription alloc] init];
    childMediaDescription.destinationEntity = mediaEntity;
    childMediaDescription.name = @"media";
    childMediaDescription.minCount = 0;
    childMediaDescription.maxCount = 0;
    childMediaDescription.deleteRule = NSCascadeDeleteRule;
    
    // Add the attribute descriptions to the entity descriptions and the entity descriptions to the managed object context.
    versionEntity.properties = @[versionValueDescription];
    childEntity.properties = @[childIdDescription, childNameDescription, childDescriptionDescription, childThumbnailDescription, childImageDescription, childMediaDescription];
    mediaEntity.properties = @[mediaNameDescription, mediaTypeDescription];
    managedObjectModel.entities = @[versionEntity, childEntity, mediaEntity];
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

@end
