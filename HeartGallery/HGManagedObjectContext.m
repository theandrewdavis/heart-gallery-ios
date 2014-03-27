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
    NSManagedObjectContext *context = [self.class sharedContext];
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
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.class sharedContext] sectionNameKeyPath:nil cacheName:nil];
}

// Parse a dictionary of events and add new events to the Core Data store.
+ (void)updateEvents:(NSArray *)remoteEvents {
    NSManagedObjectContext *context = [self.class sharedContext];
    [context performBlockAndWait:^{
        NSMutableSet *remoteEventIds = [[NSMutableSet alloc] init];
        for (NSDictionary *remoteEvent in remoteEvents) {
            // Save all remote ids to identify which local records have been deleted remotely.
            [remoteEventIds addObject:remoteEvent[@"id"]];

            // Check if there a local record id matches the remote record id.
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"gid == %@", remoteEvent[@"id"]];
            NSArray *localEvents = [context executeFetchRequest:fetchRequest error:nil];

            // If no local id matches the remote id, create a new record.
            NSManagedObject *localEvent;
            if (localEvents.count > 0) {
                localEvent = localEvents[0];
            } else {
                localEvent = [NSEntityDescription insertNewObjectForEntityForName:kEventEntityName inManagedObjectContext:context];
                [localEvent setValue:remoteEvent[@"id"] forKey:@"gid"];
            }

            // Update the local record with any changes from the remote record.
            [self updateAttributeIfChanged:localEvent withLocalKey:@"summary" andRemoteValue:remoteEvent[@"summary"]];
            [self updateAttributeIfChanged:localEvent withLocalKey:@"details" andRemoteValue:remoteEvent[@"description"]];
            [self updateAttributeIfChanged:localEvent withLocalKey:@"location" andRemoteValue:remoteEvent[@"location"]];
            [self updateAttributeIfChanged:localEvent withLocalKey:@"start" andRemoteValue:[self parseCalendarDate:remoteEvent[@"start"]]];
            [self updateAttributeIfChanged:localEvent withLocalKey:@"end" andRemoteValue:[self parseCalendarDate:remoteEvent[@"end"]]];
        }


        // Delete local records that no longer exist remotely.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
        NSArray *localEvents = [context executeFetchRequest:fetchRequest error:nil];
        for (NSManagedObject *localEvent in localEvents) {
            if (![remoteEventIds containsObject:[localEvent valueForKey:@"gid"]]) {
                [context deleteObject:localEvent];
            }
        }
        
        [context save:nil];
    }];
}

// Set a value on an NSManagedObject only if that value has changed.
+ (void)updateAttributeIfChanged:(NSManagedObject *)object withLocalKey:(NSString *)localKey andRemoteValue:(NSObject *)remoteValue {
    BOOL changed = NO;
    NSAttributeType attributeType = [(NSAttributeDescription*)object.entity.attributesByName[localKey] attributeType];

    if (remoteValue == nil || remoteValue == [NSNull null]) {
        changed = [object valueForKey:localKey] != nil;
    } else if (attributeType == NSStringAttributeType) {
        changed = ![[object valueForKey:localKey] isEqualToString:(NSString *)remoteValue];
    } else if (attributeType == NSDateAttributeType) {
        changed = ![[object valueForKey:localKey] isEqualToDate:(NSDate *)remoteValue];
    }

    if (changed) {
        [object setValue:remoteValue forKey:localKey];
    }
}

// Create a fetched results controller to fetch all events that haven't ended.
+ (NSFetchedResultsController *)createEventResultsController {
    // Find the cuttoff time by converting the beginning of today in local time to UTC.
    NSCalendar *localCalendar = [NSCalendar currentCalendar];
    NSCalendar *utcCalendar = [NSCalendar currentCalendar];
    utcCalendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *components = [localCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *utcMidnight = [utcCalendar dateFromComponents:components];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kEventEntityName];
    request.predicate = [NSPredicate predicateWithFormat:@"end > %@", utcMidnight];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"start" ascending:YES]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[self.class sharedContext] sectionNameKeyPath:nil cacheName:nil];
}

// Parse date dictionary from Google Calendar.
+ (NSDate *)parseCalendarDate:(NSDictionary *)dateData {
    // Date formatter to parse date strings that look like 2014-02-07.
    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }

    // Date formatter to parse date strings that look like 2014-02-07T14:00:00-06:00.
    static NSDateFormatter *dateTimeFormatter;
    if (!dateTimeFormatter) {
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        dateTimeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    }

    if (dateData[@"date"]) {
        return [dateFormatter dateFromString:dateData[@"date"]];
    } else if (dateData[@"dateTime"]) {
        return [dateTimeFormatter dateFromString:dateData[@"dateTime"]];
    }
    return nil;
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

@end
