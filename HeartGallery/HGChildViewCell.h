//
//  HGChildViewCell.h
//  HeartGallery
//
//  Created by Andrew Davis on 3/28/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGChildViewCell : UITableViewCell
extern const CGFloat kChildViewCellHeight;

- (void)configureCellWithChild:(NSManagedObject *)child;
@end
