//
//  NSMananagedObject+ActiveFetchRequest.h
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (ActiveFetchRequest)

// find all filtered by predicate

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate;

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
							 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

// find all sorted

+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate;

+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate
					  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext;

// find wiht aggregation

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate;

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate
						  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
