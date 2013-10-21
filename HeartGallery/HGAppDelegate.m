//
//  HGAppDelegate.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGDataController.h"
#import "HGHomeViewController.h"
#import "HGMenuViewController.h"
#import "NVSlideMenuController.h"

static NSString *kStoreFile = @"HGCoreDataStore.sqlite";
static NSString *kUrlCache = @"HGUrlCache";
static NSInteger kUrlCacheMemorySize = 20;
static NSInteger kUrlCacheDiskSize = 20;

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the main window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Initialize the URL cache.
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * kUrlCacheMemorySize diskCapacity:1024 * 1024 * kUrlCacheDiskSize diskPath:kUrlCache];
    [NSURLCache setSharedURLCache:urlCache];
    
    // Create a managed object context and use it to initialize the remote data controller.
    NSManagedObjectContext *managedObjectContext = [self createManagedObjectContext];
    [HGDataController sharedController].managedObjectContext = managedObjectContext;
    
    // Create the slide-out menu controller.
    HGMenuViewController *menuViewController = [[HGMenuViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:[[HGHomeViewController alloc] init]];
    self.window.rootViewController = [[NVSlideMenuController alloc] initWithMenuViewController:menuViewController andContentViewController:homeNavigationController];
    
    // Show the home screen.
    [self.window makeKeyAndVisible];
    return YES;
}

// Create a managed object context to store child data.
- (NSManagedObjectContext *)createManagedObjectContext {
    // Load the managed object model from a file.
    NSURL *modelFileURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelFileURL];

    // Create a persistent store in the documents directory.
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    NSURL *documentDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentDir URLByAppendingPathComponent:kStoreFile];
    
    // Try to add the sqlite store.
    NSError *error = nil;
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        //  If it fails, try deleting the sqlite file. If it still fails, just log the error.
		[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
		if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Error creating store: %@, %@", error, error.userInfo);
		}
    }
    
    // Add the persistent store coordinator to a managed object context.
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] init];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    return managedObjectContext;
}

@end
