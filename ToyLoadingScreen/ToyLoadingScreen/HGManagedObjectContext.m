//
//  HGManagedObjectContext.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/10/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGManagedObjectContext.h"
#import "HGChild.h"
#import "HGMedia.h"

#define kCoreDataStoreName @"HGCoreDataStore.sqlite"

@interface HGManagedObjectContext ()

+ (NSManagedObjectModel *)createManagedObjectModel;
+ (NSPersistentStoreCoordinator *)createPersistentStoreCoordinator:(NSManagedObjectModel *)managedObjectModel storeName:(NSString *)storeName;
+ (NSAttributeDescription *)createAttributeDescription:(NSString *)name type:(NSAttributeType)type optional:(BOOL)optional indexed:(BOOL)indexed;
+ (id)nullToNil:(id)object;

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
    NSAttributeDescription *childIdDescription = [[self class] createAttributeDescription:@"childID" type:NSInteger32AttributeType optional:NO indexed:YES];
    NSAttributeDescription *childNameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:YES];
    NSAttributeDescription *childDescriptionDescription = [[self class] createAttributeDescription:@"description" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *childThumbnailDescription = [[self class] createAttributeDescription:@"imageThumbnail" type:NSStringAttributeType optional:YES indexed:NO];
    NSAttributeDescription *childImageDescription = [[self class] createAttributeDescription:@"imageFull" type:NSStringAttributeType optional:YES indexed:NO];
    
    // Create the child entity description.
    NSEntityDescription *childEntity = [[NSEntityDescription alloc] init];
    childEntity.name = NSStringFromClass([HGChild class]);

    // Create the attribute descriptions for the media entity description.
    NSAttributeDescription *mediaNameDescription = [[self class] createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:NO];
    NSAttributeDescription *mediaTypeDescription = [[self class] createAttributeDescription:@"type" type:NSInteger32AttributeType optional:NO indexed:YES];

    // Create the media entity description.
    NSEntityDescription *mediaEntity = [[NSEntityDescription alloc] init];
    mediaEntity.name = NSStringFromClass([HGMedia class]);
    
    // Create a one-to-many relationship between a child and its media.
    NSRelationshipDescription *childMediaDescription = [[NSRelationshipDescription alloc] init];
    childMediaDescription.destinationEntity = mediaEntity;
    childMediaDescription.name = @"media";
    childMediaDescription.minCount = 0;
    childMediaDescription.maxCount = 0;
    childMediaDescription.deleteRule = NSCascadeDeleteRule;
    
    // Add the attribute descriptions to the entity descriptions and the entity descriptions to the managed object context.
    childEntity.properties = @[childIdDescription, childNameDescription, childDescriptionDescription, childThumbnailDescription, childImageDescription, childMediaDescription];
    mediaEntity.properties = @[mediaNameDescription, mediaTypeDescription];
    managedObjectModel.entities = @[childEntity, mediaEntity];
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

// Clear all children in the store and replace them with the children in the given JSON object.
- (void)replaceWithDictionary:(NSDictionary *)dictionary {
    // Delete all children in the store.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HGChild class])];
    request.includesPropertyValues = NO;
    NSError *fetchError = nil;
    NSArray *children = [self executeFetchRequest:request error:&fetchError];
    if (fetchError != nil) {
        NSLog(@"Error clearing store: %@, %@", fetchError, fetchError.userInfo);
    }
    for (HGChild* child in children) {
        [self deleteObject:child];
    }

    // Add all children in the new dataset to the managed object context.
    for (NSDictionary *newChild in dictionary[@"children"]) {
        // Add the child's attributes.
        HGChild *child = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HGChild class]) inManagedObjectContext:self];
        child.childID = @([newChild[@"id"] integerValue]);
        child.description = [self.class nullToNil:newChild[@"description"]];
        child.name = [self.class nullToNil:newChild[@"name"]];
        child.imageThumbnail = [self.class nullToNil:newChild[@"image_small"]];
        child.imageFull = [self.class nullToNil:newChild[@"image_large"]];
        
        // Add the child's media.
        NSMutableSet *media = [[NSMutableSet alloc] init];
        for (NSDictionary *newMedia in newChild[@"media"]) {
            HGMedia *mediaItem = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([HGMedia class]) inManagedObjectContext:self];
            mediaItem.name = [self.class nullToNil:newMedia[@"name"]];
            mediaItem.type = @([newMedia[@"name"] integerValue]);
            [media addObject:mediaItem];
        }
        child.media = media;
    }

    // Save the changes to the managed object context.
    NSError *saveError = nil;
    if (![self save:&saveError]) {
        NSLog(@"Error saving store: %@, %@", saveError, saveError.userInfo);
    }
}

// Core Data does not accept NSNull values, so replace instances of NSNull with nil.
+ (id)nullToNil:(id)object {
    return ([object isEqual:[NSNull null]]) ? nil : object;
}


@end
