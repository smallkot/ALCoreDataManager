//
//  NSMananagedObject+ActiveFetchRequest.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//
#import "NSManagedObject+ActiveQuery.h"

#import "ALCoreDataManager+Singleton.h"
#import "ALFetchRequest+QueryBuilder.h"

@implementation NSManagedObject (ActiveQuery)

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
							 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [[[self allInManagedObjectContext:managedObjectContext] where:predicate] request];
}

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindAllWithPredicate:predicate
						   inManagedObjectContext:managedObjectContext];
}

+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate
					  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	return [[[[self allInManagedObjectContext:managedObjectContext] where:predicate] orderedBy:description] request];
}

+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindSortedBy:description
							withPredicate:predicate
					inMangedObjectContext:managedObjectContext];
}

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate
						  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{	return [[[[self allInManagedObjectContext:managedObjectContext] where:predicate] aggregatedBy:description] request];
}

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindAggregatedBy:description
								withPredicate:predicate
						inMangedObjectContext:managedObjectContext];
}

@end
