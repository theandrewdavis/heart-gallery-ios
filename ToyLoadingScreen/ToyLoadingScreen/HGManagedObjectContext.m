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

static NSString *kCoreDataStoreName = @"HGCoreDataStore.sqlite";

@implementation HGManagedObjectContext

- (id)init {
    self = [super initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    NSAttributeDescription *versionDateDescription = [[self class] createAttributeDescription:@"date" type:NSDateAttributeType optional:NO indexed:NO];
    NSEntityDescription *versionEntity = [[NSEntityDescription alloc] init];
    versionEntity.name = NSStringFromClass([HGVersion class]);
    
    // Create the child entity description.
    NSAttributeDescription *childNameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:YES];
    NSAttributeDescription *childBiographyDescription = [[self class] createAttributeDescription:@"biography" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *childGenderDescription = [[self class] createAttributeDescription:@"gender" type:NSStringAttributeType optional:YES indexed:YES];
    NSAttributeDescription *childBirthdayDescription = [[self class] createAttributeDescription:@"birthday" type:NSDateAttributeType optional:YES indexed:YES];
    NSAttributeDescription *childThumbnailDescription = [[self class] createAttributeDescription:@"thumbnail" type:NSStringAttributeType optional:YES indexed:NO];
    NSEntityDescription *childEntity = [[NSEntityDescription alloc] init];
    childEntity.name = NSStringFromClass([HGChild class]);
    childEntity.managedObjectClassName = NSStringFromClass([HGChild class]);

    // Create the media entity description.
    NSAttributeDescription *mediaUrlDescription = [[self class] createAttributeDescription:@"url" type:NSStringAttributeType optional:NO indexed:NO];
    NSAttributeDescription *mediaTypeDescription = [[self class] createAttributeDescription:@"type" type:NSStringAttributeType optional:NO indexed:YES];
    NSEntityDescription *mediaEntity = [[NSEntityDescription alloc] init];
    mediaEntity.name = NSStringFromClass([HGMediaItem class]);
    mediaEntity.managedObjectClassName = NSStringFromClass([HGMediaItem class]);
    
    // Create a one-to-many relationship between a child and its media.
    NSRelationshipDescription *childMediaDescription = [[NSRelationshipDescription alloc] init];
    childMediaDescription.destinationEntity = mediaEntity;
    childMediaDescription.name = @"media";
    childMediaDescription.minCount = 0;
    childMediaDescription.maxCount = 0;
    childMediaDescription.deleteRule = NSCascadeDeleteRule;
    
    // Add the attribute descriptions to the entity descriptions and the entity descriptions to the managed object context.
    versionEntity.properties = @[versionValueDescription, versionDateDescription];
    childEntity.properties = @[childNameDescription, childBiographyDescription, childGenderDescription, childBirthdayDescription, childThumbnailDescription, childMediaDescription];
    mediaEntity.properties = @[mediaUrlDescription, mediaTypeDescription];
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
