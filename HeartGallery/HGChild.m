//
//  HGChild.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/11/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGChild.h"
#import "NSDictionary+Utility.h"

@implementation HGChild

@dynamic name;
@dynamic category;
@dynamic biography;
@dynamic gender;
@dynamic birthday;
@dynamic thumbnail;
@dynamic media;

// Add a child entity to the managed object context and populate it with data from a JSON dictionary.
+ (HGChild *)addChildFromData:(NSDictionary *)data toContext:(NSManagedObjectContext *)context {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
    }

    // Store child attributes replacing NSNull attributes with nil.
    HGChild *child = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    child.name = [data objectForKeyNotNull:@"name"];
    child.category = [data objectForKeyNotNull:@"category"];
    child.biography = [data objectForKeyNotNull:@"description"];
    child.gender = [data objectForKeyNotNull:@"gender"];
    child.thumbnail = [data objectForKeyNotNull:@"thumbnail"];

    // Store birthday without time.
    NSDate *birthdayWithTime = [dateFormatter dateFromString:[data objectForKeyNotNull:@"birthday"]];
    NSDateComponents *birthdayComponentsNoTime = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:birthdayWithTime];
    child.birthday = [[NSCalendar currentCalendar] dateFromComponents:birthdayComponentsNoTime];
    
    return child;
}

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
    return [NSPredicate predicateWithFormat:@"birthday > %@", [HGChild findDate:age + 1]];
}

// Create a predicate to capture all children born before or on today age years ago, meaning they're at least the given age.
+ (NSPredicate *)predicateForAgeAtLeast:(NSUInteger)age {
    return [NSPredicate predicateWithFormat:@"birthday <= %@", [HGChild findDate:age]];
}

// Create a predicate to capture all children born before or on today age years ago, meaning they're at least the given age.
+ (NSPredicate *)predicateForAgeBetween:(NSUInteger)minAge maxAge:(NSUInteger)maxAge {
    NSArray *predicates = @[[HGChild predicateForAgeAtLeast:minAge], [HGChild predicateForAgeAtMost:maxAge]];
    return [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
}

@end
