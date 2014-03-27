//
//  HGCalendarEventCell.m
//  HeartGallery
//
//  Created by Andrew Davis on 1/29/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGCalendarEventCell.h"
#import "HGCalendarEventDates.h"

@interface HGCalendarEventCell ()
@property (strong, nonatomic) NSString *summary;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@end

static const CGFloat kCalendarCellDayVericalMargin = -6;
static const CGFloat kCalendarCellDayLeftMargin = 14;
static const CGFloat kCalendarCellSummaryLeftMargin = 10;
static const CGFloat kAccessoryViewWidth = 24;

@implementation HGCalendarEventCell

- (void)layoutSubviews {
    HGCalendarEventDates *dates = [[HGCalendarEventDates alloc] initWithStartDate:self.startDate andEndDate:self.endDate];

    // Clear the view of any existing subviews.
    [[self.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    // Layout the start and end dates if this is a multiday event; otherwise, only layout the start date.
    CGFloat dateRightBorder;
    if (!dates.multiday) {
        CGRect startFrame = [self addDateWithXOffset:0 day:dates.startDay month:dates.startMonth year:dates.startYear];
        dateRightBorder = startFrame.origin.x + kCalendarCellDayLeftMargin + startFrame.size.width * 2;
    } else {
        // Add the start and end dates.
        CGRect startFrame = [self addDateWithXOffset:0 day:dates.startDay month:dates.startMonth year:dates.startYear];
        CGRect endFrame = [self addDateWithXOffset:startFrame.origin.x + startFrame.size.width day:dates.endDay month:dates.endMonth year:dates.endYear];
        dateRightBorder = endFrame.origin.x + endFrame.size.width;

        // Add the dash between the start and end dates.
        UILabel *dashLabel = [self labelWithText:@"-" fitToHeight:self.frame.size.height * .5];
        CGFloat dashLabelX = startFrame.origin.x + startFrame.size.width;
        CGFloat dashLabelY = startFrame.origin.y + startFrame.size.height / 2 - dashLabel.frame.size.height / 2;
        dashLabel.frame = CGRectMake(dashLabelX, dashLabelY, dashLabel.frame.size.width, dashLabel.frame.size.height);
        [self.contentView addSubview:dashLabel];
    }

    // Add an arrow to show that the cell can be tapped for more info.
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Add the summary text.
    UILabel *summaryLabel = [[UILabel alloc] init];
    dateRightBorder += kCalendarCellSummaryLeftMargin;
    summaryLabel.frame = CGRectMake(dateRightBorder, 0, self.frame.size.width - dateRightBorder - kAccessoryViewWidth, self.frame.size.height);
    summaryLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    summaryLabel.text = self.summary;
    summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    summaryLabel.numberOfLines = 0;
    [self.contentView addSubview:summaryLabel];
}

- (CGRect)addDateWithXOffset:(CGFloat)offset day:(NSString *)day month:(NSString *)month year:(NSString *)year {
    // Date component formatting constants.
    CGFloat dayLabelHeight = self.frame.size.height * .55;
    CGFloat monthLabelHeight = self.frame.size.height * .25;
    CGFloat yearLabelHeight = self.frame.size.height * .2;

    // Add the day label.
    UILabel *dayLabel = [self labelWithText:day fitToHeight:dayLabelHeight];
    dayLabel.frame = CGRectMake(kCalendarCellDayLeftMargin + offset, monthLabelHeight, dayLabel.frame.size.width, dayLabel.frame.size.height);
    [self.contentView addSubview:dayLabel];

    // Add the month label.
    UILabel *monthLabel = [self labelWithText:month fitToHeight:monthLabelHeight];
    CGFloat monthLabelX = dayLabel.frame.origin.x + dayLabel.frame.size.width / 2 - monthLabel.frame.size.width / 2;
    CGFloat monthLabelY = dayLabel.frame.origin.y - monthLabel.frame.size.height - kCalendarCellDayVericalMargin;
    monthLabel.frame = CGRectMake(monthLabelX, monthLabelY, monthLabel.frame.size.width, monthLabel.frame.size.height);
    monthLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:monthLabel];

    // Add the year label.
    UILabel *yearLabel = [self labelWithText:year fitToHeight:yearLabelHeight];
    CGFloat yearLabelX = dayLabel.frame.origin.x + dayLabel.frame.size.width / 2 - yearLabel.frame.size.width / 2;
    CGFloat yearLabelY = dayLabel.frame.origin.y + dayLabel.frame.size.height + kCalendarCellDayVericalMargin;
    yearLabel.frame = CGRectMake(yearLabelX, yearLabelY, yearLabel.frame.size.width, yearLabel.frame.size.height);
    yearLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:yearLabel];

    return dayLabel.frame;
}

- (UILabel *)labelWithText:(NSString *)text fitToHeight:(CGFloat)height {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    CGFloat labelFontSize = label.font.pointSize / [label.text sizeWithFont:label.font].height * height;
    label.font = [UIFont boldSystemFontOfSize:labelFontSize];
    CGSize labelSize = [label.text sizeWithFont:label.font];
    label.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (void)setSummary:(NSString *)summary startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self.summary = summary;
    self.startDate = startDate;
    self.endDate = endDate;
}

@end
