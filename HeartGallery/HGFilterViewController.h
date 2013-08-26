//
//  HGFilterViewController.h
//  HeartGallery
//
//  Created by Andrew Davis on 8/19/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HGFilterViewControllerDelegate <NSObject>

- (void)didChangePredicate:(NSPredicate *)predicate;

@end

@interface HGFilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<HGFilterViewControllerDelegate> delegate;

@end
