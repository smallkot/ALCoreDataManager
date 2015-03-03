//
//  NSManagedObject+Create.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/18/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Create)

+ (NSManagedObject*)create;
+ (NSManagedObject*)createInMangedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
