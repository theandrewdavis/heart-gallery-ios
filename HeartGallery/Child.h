//
//  Child.h
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MediaItem;

@interface Child : NSManagedObject

@property (nonatomic, retain) NSString * biography;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * thumbnail;
@property (nonatomic, retain) NSOrderedSet *media;
@end

@interface Child (CoreDataGeneratedAccessors)

- (void)insertObject:(MediaItem *)value inMediaAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMediaAtIndex:(NSUInteger)idx;
- (void)insertMedia:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMediaAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMediaAtIndex:(NSUInteger)idx withObject:(MediaItem *)value;
- (void)replaceMediaAtIndexes:(NSIndexSet *)indexes withMedia:(NSArray *)values;
- (void)addMediaObject:(MediaItem *)value;
- (void)removeMediaObject:(MediaItem *)value;
- (void)addMedia:(NSOrderedSet *)values;
- (void)removeMedia:(NSOrderedSet *)values;
@end
