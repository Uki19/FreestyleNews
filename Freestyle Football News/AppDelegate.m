//
//  AppDelegate.m
//  Freestyle Football News
//
//  Created by Uros Zivaljevic on 6/17/15.
//  Copyright (c) 2015 Uros Zivaljevic. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBar.h"
#import "Navigation.h"
#import <Pushbots/Pushbots.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    [Pushbots sharedInstanceWithAppId:@"55cf459c177959475d8b4568"];
    [self receivedPush:launchOptions];
    [[Pushbots sharedInstance] clearBadgeCount];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // This method will be called everytime you open the app
    // Register the deviceToken on Pushbots
    [[Pushbots sharedInstance] registerOnPushbots:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //Handle notification when the user click it while app is running in background or foreground.
    [self receivedPush:userInfo];
    [[Pushbots sharedInstance] clearBadgeCount];
}

-(void) receivedPush:(NSDictionary *)userInfo {
    
    //Try to get Notification from [didReceiveRemoteNotification] dictionary
    NSDictionary *pushNotification = [userInfo objectForKey:@"aps"];
    
    if(!pushNotification) {
        //Try as launchOptions dictionary
        userInfo = [userInfo objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        pushNotification = [userInfo objectForKey:@"aps"];
    }
    
    if (!pushNotification)
        return;
    
    //Get notification payload data [Custom fields]
    
    //For example: get viewControllerIdentifer for deep linking
    NSString* notificationViewControllerIdentifer = [userInfo objectForKey:@"notification_identifier"];
    
    //Set the default viewController Identifer
    if(!notificationViewControllerIdentifer)
        notificationViewControllerIdentifer = @"home";
    
    if([UIAlertController class]){
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Check it out!" message:[pushNotification valueForKey:@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        }]];
                              
    [self.window.rootViewController presentViewController:alert animated:YES completion:NULL];
    }
    else {
    UIAlertView *message =
    [[UIAlertView alloc] initWithTitle:@"Just added!"
                               message:[pushNotification valueForKey:@"alert"]
                              delegate:self
                     cancelButtonTitle:nil
                     otherButtonTitles: @"Ok",
     nil];
    
    [message show];
    }
    return;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        [[Pushbots sharedInstance] OpenedNotification];
    }
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Pushbots sharedInstance] clearBadgeCount];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
