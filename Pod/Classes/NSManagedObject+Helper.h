//
//  NSManagedObject+Helper.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

+ (NSString*)entityName;

+ (NSEntityDescription*)entityDescriptionWithMangedObjectContext:(NSManagedObjectContext*)managedObjectContext;

+ (NSAttributeDescription*)attributeDescription:(NSString*)attributeName
						  fromEntityDescription:(NSEntityDescription*)entityDescription;

@end
