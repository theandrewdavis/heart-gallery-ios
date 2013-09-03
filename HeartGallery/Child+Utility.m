//
//  Child+Utility.m
//  HeartGallery
//
//  Created by Andrew Davis on 9/2/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "Child+Utility.h"

@implementation Child (Utility)

// Find the date of today, without time, a given number of years ago.
+ (NSDate *)findDate:(NSUInteger)yearsAgo {
    // Get today's date without time.
    NSDateComponents *todayComponentsNoTime = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    NSDate *todayNoTime = [[NSCalendar currentCalendar] dateFromComponents:todayComponentsNoTime];
    
    // Get the date of the given number of years ago.
    NSDateComponents *pastDateOffsetComponents = [[NSDateComponents alloc] init];
    pastDateOffsetComponents.year = -yearsAgo;
    
    return [[NSCalendar currentCalendar] dateByAddingComponents:pastDateOffsetComponents toDate:todayNoTime options:0];
}

// Create a predicate to capture all children born after today (age + 1) years ago, meaning they're at most the given age.
+ (NSPredicate *)predicateForAgeAtMost:(NSUInteger)age {
    return [NSPredicate predicateWithFormat:@"birthday > %@", [Child findDate:age + 1]];
}

// Create a predicate to capture all children born before or on today age years ago, meaning they're at least the given age.
+ (NSPredicate *)predicateForAgeAtLeast:(NSUInteger)age {
    return [NSPredicate predicateWithFormat:@"birthday <= %@", [Child findDate:age]];
}

// Create a predicate to capture all children born before or on today age years ago, meaning they're at least the given age.
+ (NSPredicate *)predicateForAgeBetween:(NSUInteger)minAge maxAge:(NSUInteger)maxAge {
    NSArray *predicates = @[[Child predicateForAgeAtLeast:minAge], [Child predicateForAgeAtMost:maxAge]];
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

@end
