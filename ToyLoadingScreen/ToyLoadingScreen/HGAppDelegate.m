//
//  HGAppDelegate.m
//  ToyLoadingScreen
//
//  Created by Andrew Davis on 7/3/13.
//  Copyright (c) 2013 Andrew Davis. All rights reserved.
//

#import "HGAppDelegate.h"
#import "HGManagedObjectContext.h"
#import "HGHomeViewController.h"

@implementation HGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Create the main window.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Set an HGHomeViewController as top level view controller.
    HGHomeViewController *viewController = [[HGHomeViewController alloc] init];
    self.window.rootViewController = viewController;
    
    // Create a managed object context and pass it to the top level view controller.
    self.managedObjectContext = [[HGManagedObjectContext alloc] init];
    viewController.managedObjectContext = self.managedObjectContext;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
