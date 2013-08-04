//
//  HGDataController.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HGDataControllerDelegate <NSObject>

- (void)dataDidChange:(NSFetchedResultsController *)fetchedResultsController;
- (void)remoteRequestSuccess;
- (void)remoteRequestFailure;

@end

@interface HGDataController : NSObject <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id <HGDataControllerDelegate> delegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)fetchLocalData;
- (void)fetchRemoteData;

@end
