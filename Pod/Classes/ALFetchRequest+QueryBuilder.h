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

- (ALFetchRequest*)select:(NSArray*)description;

- (ALFetchRequest*)filterWithPredicate:(NSPredicate*)predicate;

/*
 - (ALFetchRequest*)sortBy:(NSArray*)description;
 
 Returns fetch request with sorting. Description is an array of arrays kinda:
 
 @[
	@["name", @(YES)],
	@["surname", @(NO)],
	@["age"]
 ]
 
 which stands for "sort by name ASC, surname DESC, age ASC". If second element is not supplied => assumed as ASC.
 
 */
- (ALFetchRequest*)sortBy:(NSArray*)description;


/*
 - (ALFetchRequest*)aggregateBy:(NSArray*)description;

 Returns fetch request with aggregations. Description is an array of arrays kinda:
 
 @[
	@["count:", @"items"],
	@["sum:", @"amount"]
 ]
 
 which stands for "COUNT(name), SUM(amount)". Available aggregations are:
 + sum:
 + count:
 + min:
 + max:
 + average:
 + median:
 
 */
- (ALFetchRequest*)aggregateBy:(NSArray*)description;

extern NSString *const kAggregatorSum;
extern NSString *const kAggregatorCount;
extern NSString *const kAggregatorMin;
extern NSString *const kAggregatorMax;
extern NSString *const kAggregatorAverage;
extern NSString *const kAggregatorMedian;

@end
