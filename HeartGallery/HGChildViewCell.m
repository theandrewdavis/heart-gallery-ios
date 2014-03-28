//
//  HGChildViewCell.m
//  HeartGallery
//
//  Created by Andrew Davis on 3/28/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGChildViewCell.h"
#import "HGWebImageView.h"

@interface HGChildViewCell ()
@end

const CGFloat kChildViewCellHeight = 90;
static const CGFloat kCellLabelLeftMargin = 10;
static const CGFloat kCellLabelRightMargin = 20;

@implementation HGChildViewCell

- (void)configureCellWithChild:(NSManagedObject *)child {
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Create child thumbnail image.
    HGWebImageView *imageView = [[HGWebImageView alloc] initWithFrame:CGRectMake(0, 0, kChildViewCellHeight - 1, kChildViewCellHeight - 1)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView setClipsToBounds:YES];
    imageView.url = [NSURL URLWithString:[child valueForKey:@"thumbnail"]];
    [self.contentView addSubview:imageView];

    // Create label for child name.
    CGFloat labelWidth = self.bounds.size.width - kChildViewCellHeight - kCellLabelLeftMargin - kCellLabelRightMargin;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kChildViewCellHeight + kCellLabelLeftMargin, 0, labelWidth, kChildViewCellHeight)];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.numberOfLines = 0;
    label.text = [child valueForKey:@"name"];
    [self.contentView addSubview:label];
}

@end
