//
//  ALCoreDataManager+Singleton.h
//  Pods
//
//  Created by Aziz U. Latypov on 8/10/14.
//
//

#import "ALCoreDataManager.h"
#import "NSManagedObject+Helper.h"
#import "ALManagedObjectFactory.h"
#import "NSManagedObject+Create.h"
#import "NSManagedObject+FetchRequest.h"

#import <CoreData/CoreData.h>

// Default Managed Object Context

@interface ALCoreDataManager (Singleton)

+ (void)setDefaultCoreDataModelName:(NSString*)modelName;
+ (instancetype)defaultManager;

+ (NSManagedObjectContext*)defaultContext;

@end

// Default Factory

@interface ALManagedObjectFactory (Singleton)

+ (ALManagedObjectFactory*)defaultFactory;

@end

// Create with Default Factory

@class ALManagedObjectFactory;

@interface NSManagedObject (CreateSingleton)

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

@end

// FetchRequest with Default Context

@class ALFetchRequest;

@interface NSManagedObject (FetchRequestSingleton)

/**
 Fetch request for query builder. Lets you build a query.
 
 @returns Returns fetch request which is used for quiery building.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 NSArray *items =
 [[[Item all] orderBy:@[@"title"]] execute];
 @endcode
 
 Example above collects all @b Items orderd by @em title.
 */
+ (ALFetchRequest*)all;

@end