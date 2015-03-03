//
//  ALCoreDataManager+Query.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/17/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Query)

// find all

+ (NSArray*)findAll;

+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate;

// find all sorted

/*
 Returns fetch request with sorting. Description is an array of arrays kinda:
 
 @[
	@["name", @(YES)],
	@["surname", @(NO)],
	@["age"]
 ]
 
 which stands for "sort by name ASC, surname DESC, age ASC". If second element is not supplied => assumed as ASC.
 
 */

+ (NSArray*)findSortedBy:(NSArray*)description;

+ (NSArray*)findSortedBy:(NSArray*)description
		   withPredicate:(NSPredicate*)predicate;

// find with aggregation

/*
 Returns fetch request with aggregations. Description is an array of arrays kinda:
 
 @[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]
 
 which stands for "COUNT(name)". Available aggregations are:
 + sum:
 + count:
 + min:
 + max:
 + average:
 + median:
 
 */

+ (NSArray*)findAggregatedBy:(NSArray*)description;

+ (NSArray*)findAggregatedBy:(NSArray*)description
			   withPredicate:(NSPredicate*)predicate;

// helper methods

+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest;

+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest
		 andManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
