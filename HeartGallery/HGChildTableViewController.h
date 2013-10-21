//
//  HGChildTableViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGFilterViewController.h"
#import "HGContentTableViewController.h"
#import "HGDataController.h"

@interface HGChildTableViewController : HGContentTableViewController <HGDataControllerDelegate, HGFilterViewControllerDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@end
