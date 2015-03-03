//
//  NSMananagedObject+ActiveFetchRequest.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "NSManagedObject+ActiveFetchRequest.h"
#import "ALCoreDataManager+Singleton.h"
#import "NSManagedObject+Helper.h"
#import "NSManagedObject+FetchRequest.h"

@implementation NSManagedObject (ActiveFetchRequest)

+ (NSFetchRequest*)fetchRequestFindAllWithPredicate:(NSPredicate*)predicate
							 inManagedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSFetchRequest *fetchRequest = [self fetchRequest];
	
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

@end
