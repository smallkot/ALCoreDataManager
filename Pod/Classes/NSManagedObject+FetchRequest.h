//
//  NSManagedObject+FetchRequest.h
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import <CoreData/CoreData.h>

@class ALFetchRequest;

@interface NSManagedObject (FetchRequest)

/**
 Fetch request for query builder. Lets you build a query.
 
 @returns Returns fetch request which is used for quiery building.
 
 @code
 NSArray *items =
 [[[Item all] orderBy:@[@"title"]] execute];
 @endcode
 
 Example above collects all @b Items orderd by @em title. The default managed context is used.
 */
+ (ALFetchRequest*)all;

/**
 Fetch request for query builder. Lets you build a query.
 
 @returns Returns fetch request which is used for quiery building.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 NSArray *items =
 [[[Item allInManagedObjectContext:context] orderBy:@[@"title"]] execute];
 @endcode
 
 Example above collects all @b Items orderd by @em title.
 */
+ (ALFetchRequest*)allInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
