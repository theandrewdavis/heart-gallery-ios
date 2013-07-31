//
//  Media.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/24/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Media : NSManagedObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* type;

@end
