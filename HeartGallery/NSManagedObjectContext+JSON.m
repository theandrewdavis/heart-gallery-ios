//
//  NSManagedObjectContext+JSON.m
//  HeartGallery
//
//  Created by Andrew Davis on 9/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "NSManagedObjectContext+JSON.h"

@implementation NSManagedObjectContext (JSON)

- (NSManagedObject *) addEntity:(NSString *)entityName fromJSON:(NSDictionary *)json {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
    for (NSString *attributeName in [entityDescription attributesByName]) {
        // Get the attribute in the JSON dictionary, replacing NSNull with nil.
        id attributeValueOrNull = [json objectForKey:attributeName];
        id attributeValue = [attributeValueOrNull isEqual:[NSNull null]] ? nil : attributeValueOrNull;
        
        // Add the attribute to the new managed object, interpreting it based on its type.
        NSAttributeType attributeType = [(NSAttributeDescription *)[entityDescription attributesByName][attributeName] attributeType];
        if (attributeType == NSDateAttributeType) {
            [entity setValue:[self formatDate:attributeValue] forKey:attributeName];
        } else {
            [entity setValue:attributeValue forKey:attributeName];
        }
    }
    return entity;
}

- (NSDate *) formatDate:(NSString *)dateString {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY-MM-dd";
    }
    
    // Format date without time.
    NSDate *dateWithTime = [dateFormatter dateFromString:dateString];
    NSDateComponents *dateComponentsNoTime = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:dateWithTime];
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponentsNoTime];
}

@end
