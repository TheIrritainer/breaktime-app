//
//  AppDelegate.m
//  Breaktime app
//
//  Created by Michael Tiel on 25/02/15.
//  Copyright (c) 2015 emtay. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        application.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber -1;
        
        
        NSLog(@"Did finish launch with options");
        
        [self createAlert:localNotif];

    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSLog(@"Entering foreground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber - 1;
    [self createAlert:notification];
}

-(void)createAlert:(UILocalNotification *)notification
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Break time"
                                          message:notification.alertBody
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSString *query = [NSString stringWithFormat:@"INSERT INTO breaktimelog (logtype, logtime, reason) values('user', strftime('%%s', 'now'), 'took breaktime') "];
                                   NavigationViewController *navRoot = (NavigationViewController *) self.window.rootViewController;
                                   
                                   [navRoot.notificationManager.db execQuery:query];
                               }];
    
    [alertController addAction:okAction];

    UIAlertAction *cancelAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                               style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction *action)
                               {
                                   NSString *query = [NSString stringWithFormat:@"INSERT INTO breaktimelog (logtype, logtime, reason) values('user', strftime('%%s', 'now'), 'dismissed breaktime') "];
                                   NavigationViewController *navRoot = (NavigationViewController *) self.window.rootViewController;
                                   
                                   [navRoot.notificationManager.db execQuery:query];
                               }];
    
    [alertController addAction:cancelAction];
    
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];

    UINavigationController *navController = (UINavigationController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Nav"];
    self.window.rootViewController = navController;
    
    ViewController *myController = (ViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"Begin"];

    [self.window.rootViewController addChildViewController:myController];
    
    
    [myController displayBreaktimeText:1];
    [myController presentViewController:alertController animated:YES completion:nil];

   
}
@end
