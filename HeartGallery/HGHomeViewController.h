//
//  HGHomeViewController.h
//  HeartGallery
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGRemoteDataController;

@interface HGHomeViewController : UIViewController
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) HGRemoteDataController *dataController;
@end
