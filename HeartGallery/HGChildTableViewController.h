//
//  HGChildTableViewController.h
//  HeartGallery
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGFilterViewController.h"
#import "HGContentTableViewController.h"

@interface HGChildTableViewController : HGContentTableViewController <HGFilterViewControllerDelegate, NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@end
