//
//  HGManagedObjectContext.m
//  HeartGallery
//
//  Created by Andrew Davis on 1/29/14.
//  Copyright (c) 2014 Andrew Davis. All rights reserved.
//

#import "HGManagedObjectContext.h"

static NSString *const kCoreDataStoreName = @"store.sqlite";
static NSString *const kChildEntityName = @"Child";
static NSString *const kAssetEntityName = @"Asset";
static NSString *const kEventEntityName = @"Event";

@implementation HGManagedObjectContext

// Get or create a managed object context.
+ (NSManagedObjectContext *)sharedContext {
    static NSManagedObjectContext *context;
    if (!context) {
        context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context performBlockAndWait:^{
            NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
            NSString *applicationDocumentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSURL *persistentStoreUrl = [NSURL fileURLWithPath:[applicationDocumentsDirectory stringByAppendingPathComponent:kCoreDataStoreName]];
            NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

            if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreUrl options:nil error:nil]) {
                [[NSFileManager defaultManager] removeItemAtURL:persistentStoreUrl error:nil];
                [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:persistentStoreUrl options:nil error:nil];
            }
            context.persistentStoreCoordinator = persistentStoreCoordinator;
        }];
    }
    return context;
}

// Update the stored child database with results from an API call.
+ (void)updateChildren:(NSArray *)children {
    NSManagedObjectContext *context = [HGManagedObjectContext sharedContext];
    [context performBlockAndWait:^{
        NSMutableSet *apiChildIds = [[NSMutableSet alloc] init];

        for (NSDictionary *apiChild in children) {
            NSManagedObject *storedChild;
            BOOL changed = NO;

            // Get the child entity if it has already been stored and check whether it has changed.
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kChildEntityName];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"hgaid == %@", apiChild[@"id"]];
            NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
            if (results.count > 0) {
                storedChild = results[0];
                changed = changed || ![[storedChild valueForKey:@"biography"] isEqualToString:apiChild[@"biography"]];
                changed = changed || ![[storedChild valueForKey:@"category"] isEqualToString:apiChild[@"category"]];
                changed = changed || ![[storedChild valueForKey:@"gender"] isEqualToString:apiChild[@"gender"]];
                changed = changed || ![[storedChild valueForKey:@"hgaid"] isEqualToString:apiChild[@"id"]];
                changed = changed || ![[storedChild valueForKey:@"name"] isEqualToString:apiChild[@"name"]];
                changed = changed || ![[storedChild valueForKey:@"thumbnail"] isEqualToString:apiChild[@"thumbnail"]];

                NSDate *apiBirthday = (apiChild[@"birthday"] == [NSNull null]) ? nil : [self parseDate:apiChild[@"birthday"]];
                NSDate *storedBirthday = ([storedChild valueForKey:@"birthday"] == [NSNull null]) ? nil : [storedChild valueForKey:@"birthday"];
                if (apiBirthday || storedBirthday) {
                    changed = changed || ![storedBirthday isEqualToDate:apiBirthday];
                }

                NSOrderedSet *storedAssets = [storedChild valueForKey:@"assets"];
                NSArray *apiAssets = apiChild[@"media"];
                changed = changed || storedAssets.count != apiAssets.count;
                for (NSManagedObject *storedAsset in storedAssets) {
                    NSMutableDictionary *storedAssetDict = [[NSMutableDictionary alloc] init];
                    storedAssetDict[@"type"] = [storedAsset valueForKey:@"type"];
                    storedAssetDict[@"url"] = [storedAsset valueForKey:@"url"];
                    changed = changed || ![apiAssets containsObject:storedAssetDict];
                }
            } else {
                changed = YES;
                storedChild = [NSEntityDescription insertNewObjectForEntityForName:kChildEntityName inManagedObjectContext:context];
            }

            // Save the child's id so we can track whther it has been deleted.
            [apiChildIds addObject:apiChild[@"id"]];

            // Update the child if it has changed.
            if (changed) {
                [storedChild setValue:apiChild[@"biography"] forKey:@"biography"];
                [storedChild setValue:apiChild[@"category"] forKey:@"category"];
                [storedChild setValue:apiChild[@"gender"] forKey:@"gender"];
                [storedChild setValue:apiChild[@"id"] forKey:@"hgaid"];
                [storedChild setValue:apiChild[@"name"] forKey:@"name"];
                [storedChild setValue:apiChild[@"thumbnail"] forKey:@"thumbnail"];

                if (apiChild[@"birthday"] == [NSNull null]) {
                    [storedChild setValue:nil forKey:@"birthday"];
                } else {
                    NSDate *birthday = [self parseDate:apiChild[@"birthday"]];
                    [storedChild setValue:birthday forKey:@"birthday"];
                }

                NSMutableOrderedSet *assets = [[NSMutableOrderedSet alloc] init];
                for (NSDictionary *apiAsset in apiChild[@"media"]) {
                    NSManagedObject *asset = [NSEntityDescription insertNewObjectForEntityForName:kAssetEntityName inManagedObjectContext:context];
                    [asset setValue:apiAsset[@"url"] forKey:@"url"];
                    [asset setValue:apiAsset[@"type"] forKey:@"type"];
                    [assets addObject:asset];
                }
                [storedChild setValue:assets forKey:@"assets"];
            }
        }

        // Delete children that weren't included in the response.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kChildEntityName];
        NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject *child in results) {
            if (![apiChildIds containsObject:[child valueForKey:@"hgaid"]]) {
                [context deleteObject:child];
            }
        }

        [context save:nil];
    }];
}

// Create a fetched results controller to get all children in alphabetical order.
+ (NSFetchedResultsController *)createChildResultsControllerWithPredicates:(NSArray *)predicates {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kChildEntityName];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]];
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[HGManagedObjectContext sharedContext] sectionNameKeyPath:nil cacheName:nil];
}

// Update the stored event database with results from an API call.
+ (void)updateEvents:(NSArray *)events {
    NSManagedObjectContext *context = [HGManagedObjectContext sharedContext];
    [context performBlockAndWait:^{
        // Add all new events.
        for (NSDictionary *eventData in events) {
            // Find an event if it is already stored or create it otherwise.
            NSManagedObject *event;
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"googleid == %@", eventData[@"id"]];
            NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
            event = (results.count > 0) ? results[0] : [NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:context];

            // Find the start date of the event.
            NSDate *date;
            if (eventData[@"start"][@"date"]) {
                date = [self parseDate:eventData[@"start"][@"date"]];
            } else if (eventData[@"start"][@"dateTime"]) {
                date = [self parseDateTime:eventData[@"start"][@"dateTime"]];
            }

            // Update event properties.
            [event setValue:eventData[@"id"] forKey:@"googleid"];
            [event setValue:eventData[@"summary"] forKey:@"summary"];
            [event setValue:date forKey:@"date"];

            // Delete cancelled events.
            if ([eventData[@"status"] isEqualToString:@"cancelled"]) {
                [context deleteObject:event];
            }
        }

        // Delete old events.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date < %@", [self today]];
        NSArray *oldEvents = [context executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject *oldEvent in oldEvents) {
            [context deleteObject:oldEvent];
        }

        [context save:nil];
    }];
}

// Create a fetched results controller to get events that will occur in the next year.
+ (NSFetchedResultsController *)createEventResultsController {
    // Get the date of today and one year from today.
    NSDate *today = [self today];
    NSDate *nextYear = [self yearFromDate:today];

    // The fetched results controller should show events in the next year sorted by date.
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date < %@)", today, nextYear];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES]];
    NSManagedObjectContext *context = [HGManagedObjectContext sharedContext];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:@"EventCache"];
}

// Parse date strings that look like 2014-02-07.
+ (NSDate *)parseDate:(NSString *)dateString {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return [dateFormatter dateFromString:dateString];
}

// Parse date strings that look like 2014-02-07T14:00:00-06:00.
+ (NSDate *)parseDateTime:(NSString *)dateString {
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    }
    return [dateFormatter dateFromString:dateString];
}

// Get the beginning of today's date in GMT.
+ (NSDate *)today {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

// Get a date in GMT by adding one year to the given date.
+ (NSDate *)yearFromDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 1;
    return [calendar dateByAddingComponents:offsetComponents toDate:date options:0];
}

@end
