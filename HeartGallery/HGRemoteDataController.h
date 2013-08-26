//
//  HGRemoteDataController.h
//  HeartGallery
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HGRemoteDataControllerDelegate <NSObject>

- (void)remoteRequestSuccess;
- (void)remoteRequestFailure;

@end

@interface HGRemoteDataController : NSObject

@property (weak, nonatomic) id <HGRemoteDataControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)fetchData;
- (BOOL)isDataStale;

@end
