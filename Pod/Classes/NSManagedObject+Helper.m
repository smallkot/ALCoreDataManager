//
//  NSManagedObject+Helper.m
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import "NSManagedObject+Helper.h"

@implementation NSManagedObject (Helper)

/**
 A class method for providing an entity name. This method can be overriden if needed.
 
 @returns Returns en entity name from caller's class name.
 
 @code
 [Item entityName];
 @endcode
 
 Example above returns NSString @@"Item".
 */
+ (NSString*)entityName
{
	Class class = self;
	NSString *entityName = NSStringFromClass(class);
	return entityName;
}

/**
 A class method for getting an EntityDescription.
 
 @param managedObjectContext A context for entity description.
 
 @returns Returns en entity description using entityName method of the class.
 
 @code
 [Item entityDescriptionWithMangedObjectContext:context];
 @endcode
 
 Example above returns NSEntityDescription with entity name @b Item.
 */
+ (NSEntityDescription*)entityDescriptionWithMangedObjectContext:(NSManagedObjectContext*)managedObjectContext
{
	NSString *entityName = [self entityName];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:managedObjectContext];
	return entity;
}

/**
 A class method for getting attribue description with given @em name from @em entityDescription.

 @param attributeName A string with name of the attribute.
 @param entityDescription An entity description for that class.
 
 @returns Returns en entity description using entityName method of the class.
 
 @code
 NSEntityDescription *e = [Item entityDescriptionWithMangedObjectContext:context];
 [Item attributeDescription:@"title" fromEntityDescription:e];
 @endcode
 
 Example above returns Item's NSAttributeDescription for attribute name @b title.
 */
+ (NSAttributeDescription*)attributeDescription:(NSString*)attributeName
						  fromEntityDescription:(NSEntityDescription*)entityDescription
{
	NSDictionary *availableKeys = [entityDescription attributesByName];
	return [availableKeys valueForKey:attributeName];
}

@end
