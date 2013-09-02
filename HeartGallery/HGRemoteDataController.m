//
//  HGRemoteDataController.m
//  HeartGallery
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGRemoteDataController.h"
#import "AFJSONRequestOperation.h"
#import "Reachability.h"
#import "Child.h"
#import "Version.h"
#import "MediaItem.h"
#import "Child+Utility.h"
#import "MediaItem+Utility.h"
#import "Version+Utility.h"

static NSString *kChildApiUrl = @"http://heartgalleryalabama.com/api.php";
static NSString *kChildApiHostName = @"heartgalleryalabama.com";
static NSString *kLastUpdateKey = @"LastUpdate";
static NSInteger kUpdateInterval = 60 * 60 * 24;

@implementation HGRemoteDataController

// Fetch a list of all children from the network.
- (void)fetchData {
    // Don't try to connect if the network is not reachable.
    if (![self networkReachable]) {
        [self.delegate remoteRequestFailure];
        return;
    }
    
    // Download a list of all children. If successful, update the local store.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kChildApiUrl]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSString *version = response.allHeaderFields[@"ETag"];
        [self update:JSON version:version];
        [self.delegate remoteRequestSuccess];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request failed: %@, %@", error.localizedDescription, error.userInfo);
        [self.delegate remoteRequestFailure];
    }];
    [operation start];
}

// Check if the network is currently reachable.
- (BOOL)networkReachable {
    Reachability *reachability = [Reachability reachabilityWithHostname:kChildApiHostName];
    return [reachability currentReachabilityStatus] != NotReachable;
}

// Delete all entities of the given entity description from the managed object context.
- (void)deleteAllEntitiesOfName:(NSString *)entityName {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.includesPropertyValues = NO;
    NSArray *entities = [self.managedObjectContext executeFetchRequest:request error:nil];
    for (NSManagedObject* entity in entities) {
        [self.managedObjectContext deleteObject:entity];
    }
}

// Check if the supplied version matches the version saved in the managed object context.
- (BOOL)isNewVersion:(NSString *)version {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Version class])];
    NSArray *versions = [self.managedObjectContext executeFetchRequest:request error:nil];
    if (versions.count == 0) {
        return YES;
    }
    Version *storedVersion = (Version *)versions[0];
    return ![storedVersion.value isEqualToString:version];
}

// Check if data has not been updated in one day.
- (BOOL)isDataStale {
    NSDate *lastUpdate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateKey];
    return !lastUpdate || [lastUpdate timeIntervalSinceNow] < -kUpdateInterval;
}

// Clear all children in the store and replace them with the children in the given JSON object.
- (void)update:(NSDictionary *)data version:(NSString *)version  {
    // Don't update the store if the version has already been saved.
    if (![self isNewVersion:version]) {
        return;
    }

    // Remove all children from the store.
    [self deleteAllEntitiesOfName:NSStringFromClass([Version class])];
    [self deleteAllEntitiesOfName:NSStringFromClass([Child class])];
    
    // Add children from the web response.
    [Version addVersion:version toContext:self.managedObjectContext];
    for (NSDictionary *childData in data[@"children"]) {
        Child *child = [Child addChildFromData:childData toContext:self.managedObjectContext];
        NSMutableOrderedSet *media = [[NSMutableOrderedSet alloc] init];
        for (NSDictionary *mediaItemData in childData[@"media"]) {
            MediaItem *mediaItem = [MediaItem addMediaItemFromData:mediaItemData toContext:self.managedObjectContext];
            [media addObject:mediaItem];
        }
        child.media = media;
    }

    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Context save failed: %@, %@", error.localizedDescription, error.userInfo);
    };
    
    // Reset the time the database was last updated.
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateKey];
}

@end
