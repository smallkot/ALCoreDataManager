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

#warning TODO: setting predicate to nil is bad idea => create methods without predicate and add predicate if needed

@implementation NSManagedObject (Query)

//
// findALl
//

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
							 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [self entityDescriptionWithMangedObjectContext:managedObjectContext];

	[fetchRequest setEntity:entity];
	
	if ([predicate isKindOfClass:NSPredicate.class]) {
		fetchRequest.predicate = predicate;
	}
	
	return fetchRequest;
}

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindAllWithPredicate:predicate
						   inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate
		  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAllWithPredicate:predicate
												   inManagedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAllWithPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAllWithPredicate:predicate
			   inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAll
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAllWithPredicate:nil
			   inManagedObjectContext:managedObjectContext];
}

//
// findSorted
//

/*
 Returns fetch request with sorting. Description is an array of arrays kinda:
 
 @[
	@["name", @(YES)],
	@["surname", @(NO)],
	@["age"]
 ]
 
 which stands for "sort by name ASC, surname DESC, age ASC". If second element is not supplied => assumed as ASC.
 
 */
+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate
					  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAllWithPredicate:predicate
												   inManagedObjectContext:managedObjectContext];
	NSMutableArray *sortDescriptors = [NSMutableArray new];
	for (NSArray *desc in description) {
		if ([desc isKindOfClass:NSArray.class]) {
			if (desc.count) {
				NSString *by = nil;
				NSNumber *asc = nil;
				if ([desc.firstObject isKindOfClass:NSString.class]) {
					by = desc.firstObject;
				}
				if (desc.count > 1) {
					asc = [desc  objectAtIndex:1];
				}
				[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:by ascending:asc.boolValue]];
			}
		}
	}
	fetchRequest.sortDescriptors = [sortDescriptors copy];
	return fetchRequest;
}

+ (NSFetchRequest*)fetchRequestFindSortedBy:(NSArray*)description
							  withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindSortedBy:description
							withPredicate:predicate
					inMangedObjectContext:managedObjectContext];
}

+ (NSArray*)findSortedBy:(NSArray*)description
		   withPredicate:(NSPredicate*)predicate
  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindSortedBy:description
													withPredicate:predicate
	  									    inMangedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findSortedBy:(NSArray*)description
		   withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findSortedBy:description
			    withPredicate:predicate
	   inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findSortedBy:(NSArray*)description
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findSortedBy:description
			    withPredicate:nil
	   inManagedObjectContext:managedObjectContext];
}

//
// findAggregated
//

/*
 Returns fetch request with aggregations. Description is an array of arrays kinda:
 
 @[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]
 
 which stands for "COUNT(name)". Available aggregations are:
 + count:
 + sum:
 
 */

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate
						  inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAllWithPredicate:predicate
												   inManagedObjectContext:managedObjectContext];
	NSMutableArray *aggregators = [NSMutableArray new];
	for (NSArray *desc in description) {
		if ([desc isKindOfClass:NSArray.class]) {
			if (desc.count > 1) {
				id first, second;
				first = desc.firstObject;
				second = [desc objectAtIndex:1];
				if (![first isKindOfClass:NSString.class] || ![second isKindOfClass:NSString.class]) {
					continue;
				}
				
				NSString *agr = (NSString*)first;
				NSString *agrName = [agr stringByReplacingOccurrencesOfString:@":" withString:@""];
				
				NSString *field = (NSString*)second;
				NSInteger fieldType = NSUndefinedAttributeType;
				
				NSEntityDescription *entity = [self entityDescriptionWithMangedObjectContext:managedObjectContext];
				NSAttributeDescription *fieldDescription = [self attributeDescription:field
																fromEntityDescription:entity];
				
				if (![fieldDescription isKindOfClass:NSAttributeDescription.class]) {
					continue;
				}
				
				fieldType = [fieldDescription attributeType];
				
				NSExpression *fieldExp = [NSExpression expressionForKeyPath:field];
				NSExpression *agrExp = [NSExpression expressionForFunction:agr arguments:@[fieldExp]];
				NSExpressionDescription *resultDescription = [[NSExpressionDescription alloc] init];
				NSString *resultName = [NSString stringWithFormat:@"%@%@",agrName,[field capitalizedString]];
				[resultDescription setName:resultName];
				[resultDescription setExpression:agrExp];
				[resultDescription setExpressionResultType:fieldType];

				[aggregators addObject:resultDescription];
			}
		}
	}
	
	if (aggregators.count) {
		fetchRequest.resultType = NSDictionaryResultType;
		[fetchRequest setPropertiesToFetch:[aggregators copy]];
	}

	return fetchRequest;
}

+ (NSFetchRequest*)fetchRequestFindAggregatedBy:(NSArray*)description
								  withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestFindAggregatedBy:description
								withPredicate:predicate
						inMangedObjectContext:managedObjectContext];
}

+ (NSArray*)findAggregatedBy:(NSArray*)description
			   withPredicate:(NSPredicate*)predicate
	  inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequestFindAggregatedBy:description
														withPredicate:predicate
												inMangedObjectContext:managedObjectContext];
	return [self findWithFetchRequest:fetchRequest andManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAggregatedBy:(NSArray*)description
			   withPredicate:(NSPredicate*)predicate
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAggregatedBy:description
					withPredicate:predicate
		   inManagedObjectContext:managedObjectContext];
}

+ (NSArray*)findAggregatedBy:(NSArray*)description
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self findAggregatedBy:description
					withPredicate:nil
		   inManagedObjectContext:managedObjectContext];
}

//
// Supporting Methods
//

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
 
 ==============================
 
 NOTE:
 
 - (void)setIncludesPendingChanges:(BOOL)yesNo
 
 As per the documentation
 
 A value of YES is not supported in conjunction with the result type  NSDictionaryResultType, including calculation of aggregate results (such as max and min). For dictionaries, the array returned from the fetch reflects the current state in the persistent store, and does not take into account any pending changes, insertions, or deletions in the context. If you need to take pending changes into account for some simple aggregations like max and min, you can instead use a normal fetch request, sorted on the attribute you want, with a fetch limit of 1.
 
 
 */

@end
