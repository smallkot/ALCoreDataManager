//
//  NSManagedObject+Create.m
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import "NSManagedObject+Create.h"
#import "NSManagedObject+Helper.h"
#import "ALCoreDataManager+Singleton.h"

#warning TODO: create object with dictionary containing fields

@implementation NSManagedObject (Create)

+ (NSManagedObject*)createInMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSString *entityName = [self entityName];
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
															inManagedObjectContext:managedObjectContext];
	return object;
}

+ (NSManagedObject*)create
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self createInMangedObjectContext:managedObjectContext];
}

@end
