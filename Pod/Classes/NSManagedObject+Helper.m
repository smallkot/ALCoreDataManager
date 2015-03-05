//
//  NSManagedObject+Helper.m
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)

+ (NSString*)entityName
{
	Class class = self;
	NSString *entityName = NSStringFromClass(class);
	return entityName;
}

+ (NSEntityDescription*)entityDescriptionWithMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSString *entityName = [self entityName];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:managedObjectContext];
	return entity;
}

+ (NSAttributeDescription*)attributeDescription:(NSString*)attributeName
						  fromEntityDescription:(NSEntityDescription*)entityDescription
{
	NSDictionary *availableKeys = [entityDescription attributesByName];
	return [availableKeys valueForKey:attributeName];
}

@end
