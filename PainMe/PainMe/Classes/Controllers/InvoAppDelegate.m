//
//  InvoAppDelegate.m
//  PainMe
//
//  Created by Garrett Christopher on 6/18/12.
//  Copyright (c) 2012 Involution Studios, Inc. All rights reserved.
//

#import "InvoAppDelegate.h"

#import "InvoBodySelectionViewController.h"

#import "InvoDataManager.h"
//#import "TestFlight.h"

@implementation InvoAppDelegate

@synthesize window = _window;


//-(void)IamPrint:(PrintThis)printing{
//
//    printing(@"me");
//
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

//    [self IamPrint:^(NSString *str){
//    
//        NSLog(@"%@",str);
//    }];

//   if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//       UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//       UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//       splitViewController.delegate = (id)navigationController.topViewController;
//    }

    [Flurry setSessionReportsOnPauseEnabled:NO];
    [Flurry setSessionReportsOnCloseEnabled:YES];
    [Flurry startSession:@"HWTNBHG34FKWNKHT9ZP5"];
    
    InvoDataManager *dtaMgr = [InvoDataManager sharedDataManager];
    [dtaMgr checkPainLocationDataBase];

//    [TestFlight takeOff:@"c35236eb-4eab-4e34-a60d-c04afc4ce2d5"];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
   // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   // Saves changes in the application's managed object context before the application terminates.
    [[InvoDataManager sharedDataManager] saveContext];
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{

    NSLog(@"App received emmory warning");
}
@end
