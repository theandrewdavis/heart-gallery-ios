//
//  HGAppDelegate.m
//  HeartGallery
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGManagedObjectContext.h"
#import "HGRemoteDataController.h"
#import "HGHomeViewController.h"

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the main window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Create a data controller to manage the list of children.
    NSManagedObjectContext *managedObjectContext = [[HGManagedObjectContext alloc] init];
    HGRemoteDataController *dataController = [[HGRemoteDataController alloc] init];
    dataController.managedObjectContext = managedObjectContext;
    
    // Create a navigation controller as the root view controller and insert the home screen into it.
    HGHomeViewController *homeViewController = [[HGHomeViewController alloc] init];
    homeViewController.managedObjectContext = managedObjectContext;
    homeViewController.dataController = dataController;
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end