//
//  HGCalendarEventDates.m
//  HeartGallery
//
//  Created by Andrew Davis on 3/27/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGCalendarEventDates.h"

@interface HGCalendarEventDates ()
@property (assign, nonatomic, readwrite) BOOL multiday;
@property (strong, nonatomic, readwrite) NSString *startDate;
@property (strong, nonatomic, readwrite) NSString *startDay;
@property (strong, nonatomic, readwrite) NSString *startMonth;
@property (strong, nonatomic, readwrite) NSString *startYear;
@property (strong, nonatomic, readwrite) NSString *endDate;
@property (strong, nonatomic, readwrite) NSString *endDay;
@property (strong, nonatomic, readwrite) NSString *endMonth;
@property (strong, nonatomic, readwrite) NSString *endYear;
@end

@implementation HGCalendarEventDates

- (id)initWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    self = [super init];
    if (self) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];

        // Format components of start date.
        NSDateComponents *startDateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        self.startDay = [NSString stringWithFormat:@"%02ld", (long)startDateComponents.day];
        self.startMonth = [[self.monthFormatter stringFromDate:startDate] uppercaseString];
        self.startYear = [NSString stringWithFormat:@"%04ld", (long)startDateComponents.year];

        // Format components of end date.
        NSDate *adjustedEndDate = [endDate dateByAddingTimeInterval:-1];
        NSDateComponents *endDateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:adjustedEndDate];
        self.endDay = [NSString stringWithFormat:@"%02ld", (long)endDateComponents.day];
        self.endMonth = [[self.monthFormatter stringFromDate:adjustedEndDate] uppercaseString];
        self.endYear = [NSString stringWithFormat:@"%04ld", (long)endDateComponents.year];

        // Check whether this is a single day or multiday event.
        self.multiday = !(startDateComponents.year == endDateComponents.year && startDateComponents.month == endDateComponents.month && startDateComponents.day == endDateComponents.day);

        // Format the start and end dates in MM/DD/YY format.
        self.startDate = [self.dateFormatter stringFromDate:startDate];
        self.endDate = [self.dateFormatter stringFromDate:adjustedEndDate];
    }
    return self;
}

- (NSDateFormatter *)monthFormatter {
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        formatter.dateFormat = @"MMM";
    }
    return formatter;
}

- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        formatter.dateStyle = NSDateFormatterShortStyle;
    }
    return formatter;
}

@end
