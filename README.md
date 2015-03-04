# ALCoreDataManager

[![CI Status](http://img.shields.io/travis/appleios/ALCoreDataManager.svg?style=flat)](https://travis-ci.org/appleios/ALCoreDataManager)
[![Version](https://img.shields.io/cocoapods/v/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![License](https://img.shields.io/cocoapods/l/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![Platform](https://img.shields.io/cocoapods/p/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)

## Usage

Import the header
```objc
#import <ALCoreDataManager/ALCoreData.h>
```

For saving the context on app termite add this code to your AppDelegate
```objc
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[ALCoreDataManager defaultManager] saveContext];
}
```

To get the NSManagedObjectContext use
```objc
[ALCoreDataManager defaultManager].managedObjectContext
```

## Create Objects

You can use simple create method to create managed object:
```objc
Item *a = [Item create];

Item *b = [Item createWithDictionary:@{
                                       @"title" : @"an item"
                                      }];

Item *c = [Item createWithDictionary:nil 
                        usingFactory:factory];

[c remove]; // will remove the item
```

## Query Builder

```objc
NSArray *items = [[Item all] execute];

NSArray *filteredItems = [[[Item all] where:predicate] execute];

NSArray *oneItem = [[[[Item all] where:predicate] limit:1] execute];

NSArray *onlyDistinctItems = [[[[Item all] whre:predicate] distinct] execute];

NSArray *orderedItems = 
[[[Item all
] orderedBy:@[
		 	  @[@"title", kOrderDESC],
			  @[@"price", kOrderASC],
              @[@"amount"]]
] execute];

NSDictionary *aggregatedItems = 
[[[[[Item all
] aggregatedBy:@[
   		         @[kAggregateSum, @"amount"],
				 @[kAggregateMedian, @"price"]
] groupedBy:@[@"country"]
] having:predicate
] execute];
```

For *orderedBy:* you may specify only the field name - by default sorting oreder is ASC.

Available aggreagations are:
* kAggregateSum
* kAggregateCount
* kAggregateMin
* kAggregateMax
* kAggregateAverage
* kAggregateMedian

## Concurrency

```objc
[[ALCoreDataManager defaultManager] performBlock:^(NSManagedObjectContext *localContext))
{
  NSArray *remoteUpdates = ...;

  ALManagedObjectFactory *factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:localContext];

  for(NSDictionary *d in remoteUpdates){
    [Item createWithDictionary:d usingFactory:factory];
  }
} andEmitNotification:@"FetchingUpdatesDone"];
```

This will automaticaly save changed into localContext and *merge* it with the defaultContext.

## Limitations

As per the [documentation](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSFetchRequest_Class/index.html#//apple_ref/occ/instp/NSFetchRequest/includesPendingChanges):

> 
> - (void)setIncludesPendingChanges:(BOOL)yesNo
> 
> A value of YES is not supported in conjunction with the result type  NSDictionaryResultType, including calculation of aggregate results (such as max and min). For dictionaries, the array returned from the fetch reflects the current state in the persistent store, and does not take into account any pending changes, insertions, or deletions in the context. If you need to take pending changes into account for some simple aggregations like max and min, you can instead use a normal fetch request, sorted on the attribute you want, with a fetch limit of 1.

So using aggregatedBy/groupedBy/having *will ignore* data, which was not saved.

## Requirements

You *must* overide method +entityName if your entitie's name differs from its class name

```objc
@implementation Item

+ (NSString*)entityName
{
	return @"AnItem";
}

@end
```

## Installation

ALCoreDataManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ALCoreDataManager"

## Author

Aziz U. Latypov, vm06lau@mail.ru

## License

ALCoreDataManager is available under the MIT license. See the LICENSE file for more info.

