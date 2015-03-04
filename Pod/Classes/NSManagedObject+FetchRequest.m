//
//  NSManagedObject+FetchRequest.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "NSManagedObject+FetchRequest.h"
#import "ALCoreDataManager+Singleton.h"
#import "NSManagedObject+Helper.h"
#import "ALFetchRequest.h"

@implementation NSManagedObject (FetchRequest)

/**
 Fetch request for query builder. Lets you build a query.
 
 @returns Returns fetch request which is used for quiery building.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 [[Item fetchRequestInManagedObjectContext:context] orderBy:@[@"title"]];
 @endcode
 
 Example above collects all @b Items orderd by @em title.
 */
+ (ALFetchRequest*)allInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext

{
	ALFetchRequest *fetchRequest = [[ALFetchRequest alloc] init];
	fetchRequest.managedObjectContext = managedObjectContext;
	NSEntityDescription *entity = [self entityDescriptionWithMangedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setIncludesPendingChanges:YES];
	
	return fetchRequest;
}

/**
 Fetch request for query builder. Lets you build a query.
 
 @returns Returns fetch request which is used for quiery building.
 
 @code
 NSArray *items =
 [[[Item fetchReques] orderBy:@[@"title"]] execute];
 @endcode
 
 Example above collects all @b Items orderd by @em title. The default managed context is used.
 */
+ (ALFetchRequest*)all
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self allInManagedObjectContext:managedObjectContext];
}

@end
