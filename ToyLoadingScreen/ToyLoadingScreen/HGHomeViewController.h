//
//  HGHomeViewController.h
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGManagedObjectContext;

@interface HGHomeViewController : UIViewController

@property (nonatomic, strong) HGManagedObjectContext *managedObjectContext;

@end
