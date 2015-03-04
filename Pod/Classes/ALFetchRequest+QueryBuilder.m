//
//  NSFetchRequest+QueryBuilder.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "ALFetchRequest+QueryBuilder.h"

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
 Fetch request for query builder. Lets you build a query with selecting only given properties.
 
 @returns Returns fetch request which is used for quiery building.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 [[Item fetchRequestInManagedObjectContext:context] orderBy:@[@"title"]];
 @endcode
 
 Example above collects all @b Items orderd by @em title.
 
 NOTE: Don't use select: with aggreateBy:.
 NOTE: Result type is automaticaly set to NSDictionaryResultType.
 */
- (ALFetchRequest*)properties:(NSArray*)properties
{
	NSArray *properiesToFetch = [self propertiesFromDescription:properties];
	self.resultType = NSDictionaryResultType;
	self.propertiesToFetch = properiesToFetch;
	return self;
}

/**
 Set an @b order for query.
 
 @returns Returns fetch request with sort descriptors set according to description parameter.
 
 @param description Is an array of arrays describing a desired sorting.
 
 @code
 NSArray *items =
 [[Item all] orderedBy:@[
	@["title", kOrderASC],
	@["price", kOrderDESC],
	@["amount"]
 ] execute];
 
 // or
 
 NSArray *items =
 [[[Item all] orderedBy:@[@title", @"amount"]
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
 [[[Item all] where:[NSPredicate predicateWithFormat:@"count > %d",minCount]] execute];
 @endcode
 
 Example above collects all @b Items where count is more than value of variable minCount.
 */
- (ALFetchRequest*)where:(NSPredicate*)predicate
{
	self.predicate = predicate;
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
 NSArray *items =
 [[[Item all] aggregatedBy:@[
	@[kAggregatorCount, @"items"],
	@[kAggregatorSum, @"amount"]
 ]] execute];
 
 NSDictionary *d = [items firstObject];
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
 NSArray *items =
 [[[[Item all] aggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]] groupedBy:@[@"county"]
 ] execute];
 
 NSDictionary *d = [items firstObject];
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
 NSArray *items =
 [[[[Item all] aggregatedBy:@[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]] groupedBy:@[@"county"]
 ] having:[NSPredicate predicateWithFormat:@"sum > 100"]
 ] execute];
 
 NSDictionary *d = [items firstObject];
 [d valueForKey:@"countItems"];
 @endcode
 
 Example above aggregates @b Items and counts @em items ASC and sums @em amount and groups by @em county.
 */
- (ALFetchRequest*)having:(NSPredicate*)predicate
{
	self.havingPredicate = predicate;
	return self;
}

/**
 Set limit on query.
 
 @returns Returns fetch request with fetch limit set accordingly.
 
 @param limit A value for fetchLimit.
 
 
 @code
 NSArray *item =
 [[[[Item all] where:[NSPredicate predicateWithFormat:@"title = %@",title]] limit:1] execute];
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
 [[[[Item all] where:[NSPredicate predicateWithFormat:@"title = %@",title]] distinct] execute];
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
- (NSArray*)execute
{
	NSError *error;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
	NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:self error:&error];
	if (!fetchedObjects || error) {
		NSLog(@"Error: Execution of the fetchRequest: %@, Failed with Description: %@",self,error);
	}
	return fetchedObjects;
}

/**
 Casts a ALFetchRequest to NSFetchRequest.
 
 @returns Returns NSFetchRequest.
 
 @code
 NSFetchRequest *request =
 [[[Item fetchReques] orderBy:@[@"title"]] request];
 @endcode
 
 Example above collects all @b Items orderd by @em title. The default managed context is used.
 */
- (NSFetchRequest *)request
{
	return (NSFetchRequest*)self;
}

// utility methods

- (NSArray*)sortDescriptorsFromDescription:(NSArray*)description
{
	NSMutableArray *sortDescriptors = [NSMutableArray new];
	for (id desc in description) {
		if(![desc isKindOfClass:NSArray.class] && ![desc isKindOfClass:NSString.class])
			continue;
		
		NSString *by = nil;
		NSString *ascString = nil;
		NSNumber *asc = nil;
		
		if ([desc isKindOfClass:NSArray.class]) {
			NSArray *a = (NSArray*)desc;
			if (a.count) {
				if ([a.firstObject isKindOfClass:NSString.class]) {
					by = a.firstObject;
				}
				if (a.count > 1) {
					ascString = [a  objectAtIndex:1];
					asc = @([ascString isEqualToString:kOrderASC]);
				}
			}
		}else if ([desc isKindOfClass:NSString.class]){
			by = (NSString*)desc;
			asc = @(YES);
		}
		[sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:by
																 ascending:asc.boolValue]];
	}
	return [sortDescriptors copy];
}

- (NSArray*)propertiesFromDescription:(NSArray*)description
{
	NSMutableArray *properties = [NSMutableArray new];
	for (NSString *field in description) {
		if ([field isKindOfClass:NSString.class]) {
			
			NSString *entityName = [self entityName];
			NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
													  inManagedObjectContext:self.managedObjectContext];
			
			NSDictionary *availableKeys = [entity attributesByName];
			NSAttributeDescription *fieldDescription = [availableKeys valueForKey:field];
			
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
				
				NSString *entityName = [self entityName];
				NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
														  inManagedObjectContext:self.managedObjectContext];
				
				NSDictionary *availableKeys = [entity attributesByName];
				NSAttributeDescription *fieldDescription = [availableKeys valueForKey:field];
				
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
