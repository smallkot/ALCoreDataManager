//
//  ALCoreDataManager+Query.h
//  Pods
//
//  Created by Aziz U. Latypov on 2/17/15.
//
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Query)

+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest;

+ (NSArray*)findWithFetchRequest:(NSFetchRequest*)fetchRequest
		 andManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
