//
//  NSManagedObject+FetchRequest.h
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import <CoreData/CoreData.h>

@class ALFetchRequest;

@interface NSManagedObject (FetchRequest)

+ (ALFetchRequest*)fetchRequest;

+ (ALFetchRequest*)fetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext;

@end
