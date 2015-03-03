//
//  NSManagedObject+Create.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Create)

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields;

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
			   inMangedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
