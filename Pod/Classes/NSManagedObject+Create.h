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

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields;

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
						usingFactory:(ALManagedObjectFactory*)factory;

- (void)remove;

@end
