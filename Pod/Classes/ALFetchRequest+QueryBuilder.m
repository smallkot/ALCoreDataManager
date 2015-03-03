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

NSString *const kAggregatorSum = @"sum:";
NSString *const kAggregatorCount = @"count:";
NSString *const kAggregatorMin = @"min:";
NSString *const kAggregatorMax = @"max:";
NSString *const kAggregatorAverage = @"average";
NSString *const kAggregatorMedian = @"median";

NSString *const kOrderASC = @"ASC";
NSString *const kOrderDESC = @"DESC";

@implementation ALFetchRequest (QueryBuilder)

- (ALFetchRequest*)orderBy:(NSArray*)description
{
	self.sortDescriptors = [self sortDescriptorsFromDescription:description];
	return self;
}

- (ALFetchRequest*)where:(NSPredicate*)predicate
{
	self.predicate = predicate;
	return self;
}

- (ALFetchRequest*)aggregateBy:(NSArray*)description
{
	NSArray *aggregators = [self aggregatorsFromDescription:description];
	if (aggregators.count) {
		self.resultType = NSDictionaryResultType;
		[self setPropertiesToFetch:aggregators];
	}
	return self;
}

- (ALFetchRequest*)groupBy:(NSArray*)description
{
	NSArray *properties = [self aggregatorsFromDescription:description];
	if (properties.count) {
		self.resultType = NSDictionaryResultType;
		
		NSArray *aggregators = [self propertiesToFetch];
		NSMutableArray *aggregatorsAndGroupProperties = [NSMutableArray arrayWithArray:properties];
		[aggregatorsAndGroupProperties addObjectsFromArray:aggregators];
		
		[self setPropertiesToFetch:aggregatorsAndGroupProperties];
	}
	return self;
}

- (ALFetchRequest*)having:(NSPredicate*)predicate
{
	self.havingPredicate = predicate;
	return self;
}

- (ALFetchRequest*)limit:(NSInteger)limit
{
	self.fetchLimit = limit;
	return self;
}

- (ALFetchRequest*)distinct
{
	self.returnsDistinctResults = YES;
	return self;
}

- (ALFetchRequest*)count
{
	[self setResultType:NSCountResultType];
	return self;
}

// utilities

- (NSArray*)sortDescriptorsFromDescription:(NSArray*)description
{
	NSMutableArray *sortDescriptors = [NSMutableArray new];
	for (NSArray *desc in description) {
		if ([desc isKindOfClass:NSArray.class]) {
			if (desc.count) {
				NSString *by = nil;
				NSString *ascString = nil;
				NSNumber *asc = nil;
				if ([desc.firstObject isKindOfClass:NSString.class]) {
					by = desc.firstObject;
				}
				if (desc.count > 1) {
					ascString = [desc  objectAtIndex:1];
					asc = @([ascString isEqualToString:kOrderASC]);
				}
				[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:by
																		 ascending:asc.boolValue]];
			}
		}
	}
	return [sortDescriptors copy];
}

- (NSArray*)propertiesFromDescription:(NSArray*)description
{
	NSMutableArray *properties = [NSMutableArray new];
	for (NSString *field in description) {
		if ([field isKindOfClass:NSString.class]) {
			
			NSEntityDescription *entity =
			[self.class entityDescriptionWithMangedObjectContext:self.managedObjectContext];
			
			NSAttributeDescription *fieldDescription = [self.class attributeDescription:field
																  fromEntityDescription:entity];
			
			if (![fieldDescription isKindOfClass:NSAttributeDescription.class]) {
				continue;
			}
			
			[properties addObject:fieldDescription];
		}
	}
	return properties;
}

- (NSArray*)aggregatorsFromDescription:(NSArray*)description
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
				NSString *resultName =
				[NSString stringWithFormat:@"%@%@",agrName,[field capitalizedString]];
				[resultDescription setName:resultName];
				[resultDescription setExpression:agrExp];
				[resultDescription setExpressionResultType:fieldType];
				
				[aggregators addObject:resultDescription];
			}
		}
	}
	return aggregators;
}

@end
