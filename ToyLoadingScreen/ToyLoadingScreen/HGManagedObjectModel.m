//
//  HGManagedObjectModel.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/9/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGManagedObjectModel.h"

@interface HGManagedObjectModel ()

+ (NSAttributeDescription *)createAttributeDescription:(NSString *)name type:(NSAttributeType)type optional:(BOOL)optional indexed:(BOOL)indexed;

@end

@implementation HGManagedObjectModel

- (id)init {
    self = [super init];
    if (self) {
        // Create the attribute descriptions for the child entity description.
        NSAttributeDescription *idDescription = [HGManagedObjectModel createAttributeDescription:@"id" type:NSInteger32AttributeType optional:NO indexed:YES];
        NSAttributeDescription *nameDescription = [HGManagedObjectModel createAttributeDescription:@"name" type:NSStringAttributeType optional:NO indexed:YES];
        NSAttributeDescription *thumbnailDescription = [HGManagedObjectModel createAttributeDescription:@"imageThumbnail" type:NSStringAttributeType optional:YES indexed:NO];
        NSAttributeDescription *imageDescription = [HGManagedObjectModel createAttributeDescription:@"imageFull" type:NSStringAttributeType optional:YES indexed:NO];
        
        // Create the child entity description and add it to the managed object context.
        NSEntityDescription *childEntity = [[NSEntityDescription alloc] init];
        childEntity.name = @"Child";
        childEntity.properties = @[idDescription, nameDescription, thumbnailDescription, imageDescription];
        self.entities = @[childEntity];
    }
    return self;
}

+ (NSAttributeDescription *)createAttributeDescription:(NSString *)name type:(NSAttributeType)type optional:(BOOL)optional indexed:(BOOL)indexed {
    NSAttributeDescription *attributeDescription = [[NSAttributeDescription alloc] init];
    attributeDescription.name = name;
    attributeDescription.attributeType = type;
    attributeDescription.optional = optional;
    attributeDescription.indexed = indexed;
    return attributeDescription;
}

@end
