//
//  NSFetchRequest+QueryBuilder.h
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import <CoreData/CoreData.h>

@class ALFetchRequest;

@interface NSFetchRequest (QueryBuilder)

/*
 NSFetchRequest *request =
 [[Item fetchRequest] where:[NSPredicate predicateWithString:@"..."]];
 */
- (ALFetchRequest*)where:(NSPredicate*)predicate;

/*
 NSFetchRequest *request =
 [[Item fetchRequest] orderBy:@[
		@["name", kOrderASC],
		@["surname", kOrderDESC],
		@["age"]
	 ]
 ];
 */
- (ALFetchRequest*)orderBy:(NSArray*)description;

/*
 NSFetchRequest *request =
 [[Item fetchRequest] aggregateBy:@[
	@[kAggragateCount, @"items"],
	@[kAggragateSum, @"amount"]
 ];
 
 Available aggregations are:
 + sum
 + count
 + min
 + max
 + average
 + median
 */
- (ALFetchRequest*)aggregateBy:(NSArray*)description;

/*
 NSFetchRequest *request =
 [[[Item fetchRequest] aggregateBy:@[
	@[kAggragateCount, @"items"],
	@[kAggragateSum, @"amount"]
 ] groupBy:@[@"country"]];
 
 NOTE: groupBy MUST be called AFTER aggregateBy:
 */
- (ALFetchRequest*)groupBy:(NSArray*)description;

/*
 NSFetchRequest *request =
 [[[[Item fetchRequest] aggregateBy:@[
	@[kAggragateCount, @"items"],
	@[kAggragateSum, @"amount"]
 ] groupBy:@[@"country"] 
 ] having:[NSPredicate predicateWithString:@"..."];
 */
- (ALFetchRequest*)having:(NSPredicate*)predicate;

// sets a fetch limit
- (ALFetchRequest*)limit:(NSInteger)limit;

// enforces only distinct
- (ALFetchRequest*)distinct;

// changed result type to NSCountResultType
- (ALFetchRequest*)count;

@end

extern NSString *const kAggregatorSum;
extern NSString *const kAggregatorCount;
extern NSString *const kAggregatorMin;
extern NSString *const kAggregatorMax;
extern NSString *const kAggregatorAverage;
extern NSString *const kAggregatorMedian;