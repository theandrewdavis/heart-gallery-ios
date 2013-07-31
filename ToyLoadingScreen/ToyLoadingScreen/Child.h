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

@property (nonatomic, strong) NSNumber* childID;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, strong) NSString* imageThumbnail;
@property (nonatomic, strong) NSString* imageFull;
@property (nonatomic, strong) NSSet* media;

@end
