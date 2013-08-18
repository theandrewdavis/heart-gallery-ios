//
//  HGChild.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface HGChild : NSManagedObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* biography;
@property (nonatomic, strong) NSString* gender;
@property (nonatomic, strong) NSDate* birthday;
@property (nonatomic, strong) NSString* thumbnail;
@property (nonatomic, strong) NSSet* media;

+ (HGChild *)addChildFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context;

@end
