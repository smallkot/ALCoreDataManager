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
Product *a = [Product create];
Product *b = [Product createWithDictionary:@{ @"title" : @"best product" }];

// or using Factory class
NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
ALManagedObjectFactory *factory =
[[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];

Product *c = [Product createWithDictionary:nil 
                              usingFactory:factory];
c.title = @"best product 2";

Product *d = [Product createWithDictionary:@{ @"title" : @"best product 3", @"price" : @(100) } 
                              usingFactory:factory];

[d remove]; // remove an object
```

## Query Builder

```objc
NSArray *allProducts = 
[[Product all] execute];

NSArray *productsFilteredWithPredicate = 
[[[Product all] where:predicate] execute];

NSArray *singleProduct = 
[[[[Product all] where:predicate] limit:1] execute];

NSArray *onlyDistinctProductTitles = 
[[[[Product all] properties:@[@"title"]] distinct] execute];

NSArray *countProducts =
[[[[Product all] where:predicate] count] execute];

NSArray *orderedItems = 
[[[Product all
] orderedBy:@[
              @[@"title", kOrderDESC],
              @[@"price", kOrderASC],
              @[@"amount"]]
] execute];

NSArray *aggregatedItems = 
[[[[[Product all
] aggregatedBy:@[
                 @[kAggregateSum, @"amount"],
                 @[kAggregateMedian, @"price"]]
] groupedBy:@[@"country"]
] having:predicate
] execute];
```

For *orderedBy:* you may omit the ordering ASC/DESC - default oreder is ASC.

Available aggreagations are:
* kAggregateSum
* kAggregateCount
* kAggregateMin
* kAggregateMax
* kAggregateAverage
* kAggregateMedian

You can also get request:
```objc
NSFetchRequest *request = [[[Product all] orderedBy:@[@"title", @"price"]] request];
NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
NSFetchedResultsController *controller =
[[NSFetchedResultsController alloc] initWithFetchRequest:request
                                    managedObjectContext:context
                                      sectionNameKeyPath:nil
                                               cacheName:nil];
[controller performFetch:nil];
```

## Concurrency

```objc
[[ALCoreDataManager defaultManager] saveAfterPerformingBlock:^(NSManagedObjectContext *localContext)
{
  NSArray *remoteUpdates = ...;

  ALManagedObjectFactory *factory = [[ALManagedObjectFactory alloc] initWithManagedObjectContext:localContext];

  for(NSDictionary *d in remoteUpdates){
    [Item createWithDictionary:d 
                  usingFactory:factory];
  }

} withCompletionHandler:^{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchingUpdatesDone" 
                                                      object:nil];
}];
```

This will automaticaly save changed into localContext and *merge* it with the defaultContext and emit the notification when done.

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

