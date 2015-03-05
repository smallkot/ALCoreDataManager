//
//  NSManagedObject+Create.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import <CoreData/CoreData.h>

@class ALManagedObjectFactory;

@interface NSManagedObject (Create)

/**
 A class method for creating new entities.
 
 @returns Returns en entity from caller's class name.
 
 @code
 Item *item = [Item create];
 @endcode
 
 Example above returns object of class Item. For building defaultFactory is used.
 */
+ (NSManagedObject*)create;

/**
 A class method for creating new entities.
 
 @returns Returns en entity from caller's class name and intialized accroding to given dictionary.
 
 @code
 Item *item = [Item createWithFields:@{
                                       @"title":@"ABC", 
                                       @"price":@(100)
 }];
 @endcode
 
 Example above returns object of class Item. For building defaultFactory is used.
 */
+ (NSManagedObject*)createWithFields:(NSDictionary*)fields;

/**
 A class method for creating new entities.
 
 @returns Returns en entity from caller's class name and intialized accroding to given dictionary.
 
 @code
 Item *item = [Item createWithFields:@{
 @"title":@"ABC",
 @"price":@(100)
 }];
 @endcode
 
 Example above returns object of class Item.
 */
+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
						usingFactory:(ALManagedObjectFactory*)factory;

/**
 Removes the called.
 
 @code
 Item *item = ...;
 // ...
 [item remove];
 @endcode
 */
- (void)remove;

@end
