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

@implementation NSManagedObject (Create)

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
	 inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSString *entityName = [self entityName];
	NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entityName
															inManagedObjectContext:managedObjectContext];
	for (NSString *key in fields) {
		id value = [fields valueForKey:key];
		[object setValue:value
				  forKey:key];
	}
	return object;
}

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self createWithFields:fields
			inMangedObjectContext:managedObjectContext];
}

@end
