//
//  HGCalendarEventDates.h
//  HeartGallery
//
//  Created by Andrew Davis on 3/27/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGCalendarEventDates : NSObject
@property (assign, nonatomic, readonly) BOOL multiday;
@property (strong, nonatomic, readonly) NSString *startDate;
@property (strong, nonatomic, readonly) NSString *startDay;
@property (strong, nonatomic, readonly) NSString *startMonth;
@property (strong, nonatomic, readonly) NSString *startYear;
@property (strong, nonatomic, readonly) NSString *endDate;
@property (strong, nonatomic, readonly) NSString *endDay;
@property (strong, nonatomic, readonly) NSString *endMonth;
@property (strong, nonatomic, readonly) NSString *endYear;

- (id)initWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
@end
