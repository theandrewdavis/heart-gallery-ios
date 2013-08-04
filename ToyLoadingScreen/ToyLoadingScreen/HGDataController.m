//
//  HGDataController.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 8/4/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGDataController.h"
#import "AFJSONRequestOperation.h"
#import "Reachability.h"
#import "HGChild.h"
#import "HGVersion.h"
#import "HGMediaItem.h"

static NSString *kChildApiUrl = @"http://ec2-54-221-46-93.compute-1.amazonaws.com/api.php";
static NSString *kChildApiHostName = @"ec2-54-221-46-93.compute-1.amazonaws.com";
static NSInteger kChildFetchRequestBatchSize = 40;

@implementation HGDataController

// Fetch a list of all children stored on the device.
- (void)fetchLocalData {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HGChild class])];
    request.fetchBatchSize = kChildFetchRequestBatchSize;
    NSSortDescriptor *sortNameDescending = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    request.sortDescriptors = @[sortNameDescending];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Fetch request failed: %@, %@", error.localizedDescription, error.userInfo);
    }
}

// When local data changes, notify the delegate.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate dataDidChange:controller];
}

// Fetch a list of all children from the network.
- (void)fetchRemoteData {
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([HGVersion class])];
    NSArray *versions = [self.managedObjectContext executeFetchRequest:request error:nil];
    if (versions.count == 0) {
        return YES;
    }
    HGVersion *storedVersion = (HGVersion *)versions[0];
    return ![storedVersion.value isEqualToString:version];
}

// Clear all children in the store and replace them with the children in the given JSON object.
- (void)update:(NSDictionary *)data version:(NSString *)version  {
    if (![self isNewVersion:version]) {
        return;
    }
    
    // Delete all entities in the context.
    [self deleteAllEntitiesOfName:NSStringFromClass([HGVersion class])];
    [self deleteAllEntitiesOfName:NSStringFromClass([HGChild class])];
    
    // Recerate all entities from JSON data.
    [HGVersion addVersion:version toContext:self.managedObjectContext];
    for (NSDictionary *childData in data[@"children"]) {
        HGChild *child = [HGChild addChildFromData:childData toContext:self.managedObjectContext];
        NSMutableSet *media = [[NSMutableSet alloc] init];
        for (NSDictionary *mediaItemData in childData[@"media"]) {
            HGMediaItem *mediaItem = [HGMediaItem addMediaItemFromData:mediaItemData toContext:self.managedObjectContext];
            [media addObject:mediaItem];
        }
        child.media = media;
    }
    
    // Save the changes to the managed object context.
    [self.managedObjectContext save:nil];
}

@end
