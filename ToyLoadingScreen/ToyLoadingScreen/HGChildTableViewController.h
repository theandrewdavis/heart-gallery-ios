//
//  HGChildTableViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGDataController.h"

@interface HGChildTableViewController : UITableViewController <HGDataControllerDelegate>

@property (nonatomic, strong) HGDataController *dataController;

@end
