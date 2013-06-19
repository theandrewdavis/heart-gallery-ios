//
//  HGChildTableViewController.h
//  ToyJsonTable
//
//  Created by Andrew Davis on 6/15/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGChildTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *children;

- (id)initWithChildren:(NSArray *)children;

@end
