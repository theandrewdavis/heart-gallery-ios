//
//  HGDataController.h
//  HeartGallery
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HGDataControllerDelegate <NSObject>
- (void)remoteRequestSuccess;
- (void)remoteRequestFailure;
@end

@interface HGDataController : NSObject
@property (weak, nonatomic) id <HGDataControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
+ (HGDataController *)sharedController;
- (void)fetchData;
- (BOOL)isDataStale;
@end
