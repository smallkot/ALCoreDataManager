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
						usingFactory:(ALManagedObjectFactory*)factory;
{
	NSString *entityName = [self entityName];
	NSManagedObject *object = [factory createObjectForEntityName:entityName];
	
	for (NSString *key in fields) {
		id value = [fields valueForKey:key];
		[object setValue:value
				  forKey:key];
	}
	return object;
}

- (void)remove
{
	[self.managedObjectContext deleteObject:self];
}

@end
