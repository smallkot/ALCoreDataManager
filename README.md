# ALCoreDataManager

[![CI Status](http://img.shields.io/travis/appleios/ALCoreDataManager.svg?style=flat)](https://travis-ci.org/appleios/ALCoreDataManager)
[![Version](https://img.shields.io/cocoapods/v/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![License](https://img.shields.io/cocoapods/l/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)
[![Platform](https://img.shields.io/cocoapods/p/ALCoreDataManager.svg?style=flat)](http://cocoadocs.org/docsets/ALCoreDataManager)

## Usage

Import these files
```objc
#import <ALCoreDataManager/ALCoreDataManager+Singleton.h>
#import <ALCoreDataManager/NSManagedObject+Query.h>
#import <ALCoreDataManager/NSManagedObject+Create.h>
```

Than in your AppDeligate before any other calls to ALCoreDataManager add:
```objc
[ALCoreDataManage setDefaultCoreDataModelName:@"<#Model#>"];
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
Item *item = [Item create];
```

## Active Record Style Queries

You can use active record style queries.

### Find All
```objc
[Item findAll];

[Item findAllWithPredicate:[NSPredicate ]];
```

### Find All Sorted:

```objc
+ (NSArray*)findSortedBy:(NSArray*)description;
+ (NSArray*)findSortedBy:(NSArray*)description andPredicate:(NSPredicate*)predicate;

/*
	Description is an array of arrays kinda:

	@[
		@["name", @(YES)],
		@["surname", @(NO)],
		@["age"]
	]

	which stands for "sort by name ASC, surname DESC, age ASC". If second element is not supplied => assumed as ASC.

*/
```

### Find with Aggregation (sum:, count:, ...)

```objc
+ (NSArray*)findAggregatedBy:(NSArray*)description;
+ (NSArray*)findAggregatedBy:(NSArray*)description andPredicate:(NSPredicate*)predicate;

/*
	Returns fetch request with aggregations. Description is an array of arrays kinda:

	@[
		@["count:", @"items"],
		@["sum:", @"amount"]
	]

	which stands for "COUNT(name)". Available aggregations are:
		+ count:
		+ sum:
		+ ...

*/
```

## Requirements

You MUST overide method +entityName if your entitie's name differs from its class name

```objc
+ (NSString*)entityName
{
	return @"Item";
}
```

## Installation

ALCoreDataManager is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ALCoreDataManager"

## Author

Aziz U. Latypov, vm06lau@mail.ru

## License

ALCoreDataManager is available under the MIT license. See the LICENSE file for more info.

