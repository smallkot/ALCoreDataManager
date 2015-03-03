//
//  ALCoreDataManager+Query.m
//  Pods
//
//  Created by Aziz U. Latypov on 2/17/15.
//
//

#import "NSManagedObject+Query.h"
#import "NSManagedObject+Helper.h"
#import "ALCoreDataManager+Singleton.h"
#import "NSManagedObject+ActiveFetchRequest.h"

#warning TODO: add COUNT fetches

@implementation NSManagedObject (Query)

/**
 Find all and filter with given predicate.
 
 @returns Returns fetch request with predicate set accordingly.
 
 @param predicate A predicate for filtering the results of the fetch.
 @param managedObjectContext Context for fetch request.
 
 @code
 [Item findAllWithPredicate:[NSPredicate predicateWithString:@"count > 10"] 
	 inManagedObjectContext:context];
 @endcode
 
 Example above collects all @b Items where @em count is more than 10.
 */
+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate
		  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAllWithPredicate:predicate
												   inManagedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

/**
 Find all and filter with given predicate.
 
 @returns Returns fetch request with predicate set accordingly.
 
 @param predicate A predicate for filtering the results of the fetch.
 
 @code
 [Item findAllWithPredicate:[NSPredicate predicateWithString:@"count > 10"]];
 @endcode
 
 Example above collects all @b Items where @em count is more than 10. The default managed context is used.
 */
+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAllWithPredicate:predicate
			   inManagedObjectContext:managedObjectContext];
}

/**
 Find all and filter with given predicate.
 
 @returns Returns fetch request with predicate for given entity.
 
 @code
 [Item findAll];
 @endcode
 
 Example above collects all @b Items. The default managed context is used.
 */
+ (NSArray*)findAll
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAllWithPredicate:nil
			   inManagedObjectContext:managedObjectContext];
}

/**
 Find All and Order.
 
 @returns Returns fetch request with sort descriptors set according to description parameter.

 @param description Is an array of arrays describing a desired sorting.
 @param predicate A predicate for filtering the results of the fetch.
 @param managedObjectContext Context for fetch request.
 
 @code
 [Item findSortedBy:@[
	@["name", kOrderASC],
	@["surname", kOrderDESC],
	@["age"]
 ] withPredicate:nil
 inManagedObjectContext:context];
 @endcode
 
 Example above collects all @b Items sorted by @em name ASC and @em surname DESC and @em age ASC. The default sort oreder is ASC.
 */
+ (NSArray*)findSortedBy:(NSArray*)description
		   withPredicate:(NSPredicate*)predicate
  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindSortedBy:description
													withPredicate:predicate
	  									    inMangedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

/**
 Find All and Order.
 
 @returns Returns fetch request with sort descriptors set according to description parameter.
 
 @param description Is an array of arrays describing a desired sorting.
 @param predicate A predicate for filtering the results of the fetch.
 
 @code
 [Item findSortedBy:@[
	@["name", kOrderASC],
	@["surname", kOrderDESC],
	@["age"]
 ] withPredicate:nil];
 @endcode
 
 Example above collects all @b Items sorted by @em name ASC and @em surname DESC and @em age ASC. 
 The default sort oreder is ASC. The default managed context is used.
 */
+ (NSArray*)findSortedBy:(NSArray*)description
		   withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findSortedBy:description
			    withPredicate:predicate
	   inManagedObjectContext:managedObjectContext];
}

/**
 Find All and Order.
 
 @returns Returns fetch request with sort descriptors set according to description parameter.
 
 @param description Is an array of arrays describing a desired sorting.
 
 @code
 [Item findSortedBy:@[
	@["name", kOrderASC],
	@["surname", kOrderDESC],
	@["age"]
 ]];
 @endcode
 
 Example above collects all @b Items sorted by @em name ASC and @em surname DESC and @em age ASC. 
 The default sort oreder is ASC. The default managed context is used.
 */
+ (NSArray*)findSortedBy:(NSArray*)description
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findSortedBy:description
			    withPredicate:nil
	   inManagedObjectContext:managedObjectContext];
}

/**
 Aggregator functions over items.
 
 @returns Returns fetch request with aggregations set according to description parameter.
 
 @param description Is an array of arrays describing a desired aggregations. 
 Available aggregation functions are 
 @b count,
 @b sum,
 @b min, 
 @b max,
 @b average,
 @b median.
 
 @param predicate A predicate for filtering the results of the fetch.
 @param managedObjectContext Context for fetch request.
 
 @code
 [Collection findAggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ] withPredicate:nil
 inManagedObjectContext:context];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount.
 */
+ (NSArray*)findAggregatedBy:(NSArray*)description
			   withPredicate:(NSPredicate*)predicate
	  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAggregatedBy:description
														withPredicate:predicate
												inMangedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

/**
 Aggregator functions over items.
 
 @returns Returns fetch request with aggregations set according to description parameter.
 
 @param description Is an array of arrays describing a desired aggregations.
 Available aggregation functions are
 @b count,
 @b sum,
 @b min,
 @b max,
 @b average,
 @b median.
 
 @param predicate A predicate for filtering the results of the fetch.
 
 @code
 [Collection findAggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ] withPredicate:nil];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount.
 The default managed context is used.
 */
+ (NSArray*)findAggregatedBy:(NSArray*)description
			   withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAggregatedBy:description
					withPredicate:predicate
		   inManagedObjectContext:managedObjectContext];
}

/**
 Aggregator functions over items.
 
 @returns Returns fetch request with aggregations set according to description parameter.
 
 @param description Is an array of arrays describing a desired aggregations.
 Available aggregation functions are
 @b count,
 @b sum,
 @b min,
 @b max,
 @b average,
 @b median.
 
 @code
 [Collection findAggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ] withPredicate:nil
 inManagedObjectContext:context];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount.
 The default managed context is used.
 */
+ (NSArray*)findAggregatedBy:(NSArray*)description
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAggregatedBy:description
					withPredicate:nil
		   inManagedObjectContext:managedObjectContext];
}

//
// Helper Methods
//

/**
 Performs given fetch request using specified managed object context.
 
 @returns Returns an array of fetched objects.
 
 @param fetchRequest Fetch request to be executed.
 @param managedObjectContext Context for fetch request.
 
 @code
 [Item findWithFetchRequest:fetchRequest andManagedObjectContext:context];
 @endcode
 
 Example above returns an array of items according to given fetcheRequest.
 */
+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest
		 andManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSError *error = nil;
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest
																  error:&error];
	if (fetchedObjects == nil) {
		NSLog(@"Error: %@",error);
		abort();
	}
	return fetchedObjects;
}

/**
 Performs given fetch request using specified managed object context.
 
 @returns Returns an array of fetched objects.
 
 @param fetchRequest Fetch request to be executed.
 
 @code
 [Item findWithFetchRequest:fetchRequest andManagedObjectContext:context];
 @endcode
 
 Example above returns an array of items according to given fetcheRequest.
 
 */
+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findWithFetchRequest:fetchRequest
			  andManagedObjectContext:managedObjectContext];
}

/*
 
 COUNT
 ====
 
 There seems to be no difference at all (only that one returns an NSUInteger and the other returns an NSArray containing an NSNumber).
 
 Setting the launch argument
 
 -com.apple.CoreData.SQLDebug 3
 reveals that both
 
 NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
 NSUInteger count = [context countForFetchRequest:request error:NULL];
 and
 
 NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
 [request setResultType:NSCountResultType];
 NSArray *result = [context executeFetchRequest:request error:NULL];
 execute exactly the same SQLite statement
 
 SELECT COUNT( DISTINCT t0.Z_PK) FROM ZEVENT t0
 
 */

@end
