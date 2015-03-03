//
//  NSFetchRequest+QueryBuilder.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "ALFetchRequest+QueryBuilder.h"
#import "NSManagedObject+Helper.h"
#import "ALCoreDataManager+Singleton.h"
#import "ALFetchRequest.h"

#warning TODO: leave the AR style queries and implement Query builder (like [[[Item fetchRequest] sortBy:@[...]] filterWithPredicate:...] )

NSString *const kAggregatorSum = @"sum:";
NSString *const kAggregatorCount = @"count:";
NSString *const kAggregatorMin = @"min:";
NSString *const kAggregatorMax = @"max:";
NSString *const kAggregatorAverage = @"average";
NSString *const kAggregatorMedian = @"median";

@implementation ALFetchRequest (QueryBuilder)

- (ALFetchRequest*)select:(NSArray*)description
{
	self.propertiesToFetch = description;
	return self;
}

- (ALFetchRequest*)orderBy:(NSArray*)description
{
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
	self.sortDescriptors = [sortDescriptors copy];
	return self;
}

- (ALFetchRequest*)where:(NSPredicate*)predicate
{
	self.predicate = predicate;
	return self;
}

- (ALFetchRequest*)aggregateBy:(NSArray*)description
{
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
				
				NSEntityDescription *entity =
				[self.class entityDescriptionWithMangedObjectContext:self.managedObjectContext];
				
				NSAttributeDescription *fieldDescription = [self.class attributeDescription:field
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
		self.resultType = NSDictionaryResultType;
		[self setPropertiesToFetch:[aggregators copy]];
	}
	return self;
}

- (ALFetchRequest*)groupBy:(NSArray*)description
{
	return self;
}

- (ALFetchRequest*)having:(NSPredicate*)predicate
{
	return self;
}

- (ALFetchRequest*)limit:(NSInteger)limit
{
	return self;
}

- (ALFetchRequest*)distinct
{
	return self;
}

@end
