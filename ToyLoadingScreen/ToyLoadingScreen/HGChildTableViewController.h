//
//  HGChildTableViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGRemoteDataController.h"

@interface HGChildTableViewController : UITableViewController// <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) HGRemoteDataController *remoteDataController;

@end
