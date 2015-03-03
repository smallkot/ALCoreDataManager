//
//  ALAppDelegate.m
//  ALCoreDataManager
//
//  Created by CocoaPods on 08/10/2014.
//  Copyright (c) 2014 aziz u. latypov. All rights reserved.
//

#import "ALAppDelegate.h"
#import <ALCoreDataManager/ALCoreDataManager+Singleton.h>
#import <ALCoreDataManager/NSManagedObject+Query.h>
#import <ALCoreDataManager/NSManagedObject+Create.h>

#import "Item.h"

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [ALCoreDataManager setDefaultCoreDataModelName:@"Model"];
    
    NSLog(@"%@",[ALCoreDataManager defaultManager].managedObjectContext);
	
//	Item *a = (Item*)[Item create];
//	a.title = @"A";
//	a.price = @(100);
//	a.amount = @(100);
//	
//	Item *b = (Item*)[Item create];
//	b.title = @"B";
//	b.price = @(150);
//	b.amount = @(200);
//
//	Item *c = (Item*)[Item create];
//	c.title = @"C";
//	c.price = @(200);
//	c.amount = @(300);
//	
//	NSLog(@"All:\n %@",
//	[Item findAll]);
//	
//	NSLog(@"All with price > 100:\n %@",
//	[Item findAllWithPredicate:[NSPredicate predicateWithFormat:@"price > 100"]]);
//
//	NSLog(@"All sorted by price DESC, title ASC:\n %@",
//	[Item findSortedBy:@[
//						 @[@"price", @(NO)],
//						 @[@"title"]
//						 ]]);
//
//	NSLog(@"All sorted by price DESC, title ASC and price > 100:\n %@",
//	[Item findSortedBy:@[
//						 @[@"price", @(NO)],
//						 @[@"title"]
//						 ]
//		 withPredicate:[NSPredicate predicateWithFormat:@"price > 100"]]);
//	
//	[[ALCoreDataManager defaultManager] saveContext];
//	
//	NSLog(@"Sum amount:\n %@",
//	[Item findAggregatedBy:@[
//							 @[@"sum:", @"amount"]
//							 ]
//			 withPredicate:[NSPredicate predicateWithFormat:@"price > 0"]]);
//	
//	NSArray *all = [Item findAll];
//	for (Item *item in all) {
//		[[ALCoreDataManager defaultManager].managedObjectContext deleteObject:item];
//	}
//
//	[[ALCoreDataManager defaultManager] saveContext];
	
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

@end
