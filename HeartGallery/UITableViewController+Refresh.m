//
//  UITableViewController+Refresh.m
//  HeartGallery
//
//  Created by Andrew Davis on 9/18/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "UITableViewController+Refresh.h"

@implementation UITableViewController (Refresh)

// Show refresh control and scroll the table up to display it.
- (void)beginVisualRefreshing {
    [self.refreshControl beginRefreshing];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
    } completion:nil];
}

@end
