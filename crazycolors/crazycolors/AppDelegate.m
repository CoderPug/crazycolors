//
//  AppDelegate.m
//  crazycolors
//
//  Created by Santex on 16/04/14.
//  Copyright (c) 2014 Santex. All rights reserved.
//

#import "AppDelegate.h"
#import "PNImports.h"

static NSString *kPubNubPublishKey = @"pub-c-ae8c55a7-a336-4beb-a9fa-4db8dadd742e";
static NSString *kPubNubSubscribeKey = @"sub-c-dd51faf4-b5dc-11e3-85fc-02ee2ddab7fe";
static NSString *kPubNubSecretKey = @"sec-c-MmQxYzg0YTYtYzg0MC00MzEzLThhMzgtZjBmNGQ4ZWI5NWJl";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceUUID"];
    
    if (!UUID) {
        
        UUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:UUID forKey:@"DeviceUUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    PNConfiguration *pubnubConfiguration = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                                        publishKey:kPubNubPublishKey
                                                                      subscribeKey:kPubNubSubscribeKey
                                                                         secretKey:kPubNubSecretKey];
    [PubNub setDelegate:self];
    [PubNub setClientIdentifier:UUID];
    [pubnubConfiguration setPresenceHeartbeatInterval:2];
    [PubNub setConfiguration:pubnubConfiguration];
    [PubNub connect];

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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark PubNubDelegate

- (void)pubnubClient:(PubNub *)client didReceiveMessage:(PNMessage *)message {
        
}

@end
