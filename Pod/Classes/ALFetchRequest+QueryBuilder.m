//
//  NSFetchRequest+QueryBuilder.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "ALFetchRequest+QueryBuilder.h"
#import "NSManagedObject+Helper.h"

NSString *const kAggregatorSum = @"sum:";
NSString *const kAggregatorCount = @"count:";
NSString *const kAggregatorMin = @"min:";
NSString *const kAggregatorMax = @"max:";
NSString *const kAggregatorAverage = @"average:";
NSString *const kAggregatorMedian = @"median:";

NSString *const kOrderASC = @"ASC";
NSString *const kOrderDESC = @"DESC";

@implementation ALFetchRequest (QueryBuilder)

/**
 Set an @b order for query.
 
 @returns Returns fetch request with sort descriptors set according to description parameter.
 
 @param description Is an array of arrays describing a desired sorting.
 
 @code
 NSArray *items =
 [[Item all] orderedBy:@[
	@["name", kOrderASC],
	@["surname", kOrderDESC],
	@["age"]
 ] execute];
 @endcode
 
 Example above collects all @b Items sorted by @em name ASC and @em surname DESC and @em age ASC.
 */
- (ALFetchRequest*)orderedBy:(NSArray*)description
{
	self.sortDescriptors = [self sortDescriptorsFromDescription:description];
	return self;
}

/**
 Set a @b predicate on query.
 
 @returns Returns fetch request with predicate set accordingly.
 
 @param predicate A predicate format string as for +predicateWithFormat:.
 
 @code
 NSArray *items =
 [[[Item all] where:@"count > %d",minCount] execute];
 @endcode
 
 Example above collects all @b Items where count is more than value of variable minCount.
 */
- (ALFetchRequest*)where:(NSString*)predicate, ...
{
	va_list argumentList;
	NSPredicate *p = [NSPredicate predicateWithFormat:predicate
											arguments:argumentList];
	self.predicate = p;
	return self;
}

/**
 Set an aggregator functions on query.
 
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
 NSDictionary *d =
 [[[Item all] aggregatedBy:@[
	@[kAggregatorCount, @"items"],
	@[kAggregatorSum, @"amount"]
 ]] execute];
 
 [d valueForKey:@"countItems"];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount.
 */
- (ALFetchRequest*)aggregatedBy:(NSArray*)description
{
	NSArray *aggregators = [self aggregatorsFromDescription:description];
	if (aggregators.count) {
		self.resultType = NSDictionaryResultType;
		[self setPropertiesToFetch:aggregators];
	}
	return self;
}

/**
 Set grouping on aggregated query.
 
 @returns Returns fetch request with grouping set according to description parameter.
 
 @param description Is an array
 
 @code
 NSDictionary *d =
 [[[[Item all] aggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]] groupedBy:@[@"county"]
 ] execute];
 
 [d valueForKey:@"countItems"];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount and groups by @em county.
 */
- (ALFetchRequest*)groupedBy:(NSArray*)description
{
	NSArray *properties = [self propertiesFromDescription:description];
	if (properties.count) {
		self.resultType = NSDictionaryResultType;
		
		NSArray *aggregators = [self propertiesToFetch];
		NSMutableArray *propertiesAndAggregators = [NSMutableArray arrayWithArray:properties];
		[propertiesAndAggregators addObjectsFromArray:aggregators];
		
		[self setPropertiesToGroupBy:properties];
		[self setPropertiesToFetch:propertiesAndAggregators];
	}
	return self;
}

/**
 Set an @em having on aggregated query.
 
 @returns Returns fetch request with having set according to description parameter.
 
 @param description Is an array
 
 @code
 NSDictionary *d =
 [[[[Item all] aggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]] groupedBy:@[@"county"]
 ] having:@"sum > 100"
 ] execute];
 
 [d valueForKey:@"countItems"];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount and groups by @em county.
 */
- (ALFetchRequest*)having:(NSString*)predicate, ...
{
	va_list argumentList;
	NSPredicate *p = [NSPredicate predicateWithFormat:predicate
											arguments:argumentList];
	self.havingPredicate = p;
	return self;
}

/**
 Set limit on query.
 
 @returns Returns fetch request with fetch limit set accordingly.
 
 @param limit A value for fetchLimit.
 
 
 @code
 NSArray *item =
 [[[[Item all] where:@"title == %@",title] limit:1] execute];
 @endcode
 
 Example above gets not more than 1 @b Item with given @em title.
 */
- (ALFetchRequest*)limit:(NSInteger)limit
{
	self.fetchLimit = limit;
	return self;
}

/**
 Set returnsDistinctResults to YES.
 
 @returns Returns fetch request with only distinct set to YES.
 
 
 @code
 NSArray *item =
 [[[[Item all] where:@"title == %@",title] distinct] execute];
 @endcode
 
 Example above gets only distinct @b Item with given @em title.
 */
- (ALFetchRequest*)distinct
{
	self.returnsDistinctResults = YES;
	return self;
}

/**
 Set returnsDistinctResults to YES.
 
 @returns Returns fetch request with only distinct set to YES.
 
 
 @code
 NSArray *item =
 [[[[Item all] where:@"title == %@",title] distinct] execute];
 @endcode
 
 Example above gets only distinct @b Item with given @em title.
 */
- (ALFetchRequest*)count
{
	[self setResultType:NSCountResultType];
	return self;
}

/**
 Execute given request.
 
 @returns Returns fetch request result (NSArray or NSDictionary).
 
 @code
 NSArray *item =
 [[[[Item all] where:@"title == %@",title] distinct] execute];
 @endcode
 
 Example above gets only distinct @b Item with given @em title.
 */
- (id)execute
{
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	return [managedObjectContext executeFetchRequest:self
											   error:nil];
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
