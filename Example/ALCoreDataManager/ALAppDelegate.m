//
//  ALAppDelegate.m
//  ALCoreDataManager
//
//  Created by CocoaPods on 08/10/2014.
//  Copyright (c) 2014 aziz u. latypov. All rights reserved.
//

#import "ALAppDelegate.h"

#import <ALCoreDataManager/ALCoreData.h>

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ALCoreDataManager defaultManager] saveContext];
}

@end
