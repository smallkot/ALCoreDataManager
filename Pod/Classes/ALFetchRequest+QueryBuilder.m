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

- (ALFetchRequest*)properties:(NSArray*)properties
{
	NSArray *properiesToFetch = [self propertiesFromDescription:properties];
	self.resultType = NSDictionaryResultType;
	self.propertiesToFetch = properiesToFetch;
	return self;
}

- (ALFetchRequest*)orderedBy:(NSArray*)description
{
	self.sortDescriptors = [self sortDescriptorsFromDescription:description];
	return self;
}

- (ALFetchRequest*)where:(NSPredicate*)predicate
{
	self.predicate = predicate;
	return self;
}

- (ALFetchRequest*)aggregatedBy:(NSArray*)description
{
	NSArray *aggregators = [self aggregatorsFromDescription:description];
	if (aggregators.count) {
		self.resultType = NSDictionaryResultType;
		[self setPropertiesToFetch:aggregators];
	}
	return self;
}

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
