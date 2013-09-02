//
//  MediaItem.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Child;

@interface MediaItem : NSManagedObject

@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Child *child;

@end
