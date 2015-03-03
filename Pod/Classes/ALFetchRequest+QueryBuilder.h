//
//  NSFetchRequest+QueryBuilder.h
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import <CoreData/CoreData.h>

#import "ALFetchRequest.h"

@interface ALFetchRequest (QueryBuilder)

- (ALFetchRequest*)where:(NSString*)predicate, ...;

- (ALFetchRequest*)orderedBy:(NSArray*)description;

- (ALFetchRequest*)aggregatedBy:(NSArray*)description;

- (ALFetchRequest*)groupedBy:(NSArray*)description;

- (ALFetchRequest*)having:(NSString*)predicate, ...;

- (ALFetchRequest*)limit:(NSInteger)limit;

- (ALFetchRequest*)distinct;

- (ALFetchRequest*)count;

- (id)execute;

@end

extern NSString *const kAggregatorSum;
extern NSString *const kAggregatorCount;
extern NSString *const kAggregatorMin;
extern NSString *const kAggregatorMax;
extern NSString *const kAggregatorAverage;
extern NSString *const kAggregatorMedian;

extern NSString *const kOrderASC;
extern NSString *const kOrderDESC;
