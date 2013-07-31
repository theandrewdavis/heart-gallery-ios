//
//  HGChildTableViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGManagedObjectContext;

@interface HGChildTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) HGManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
