//
//  NSManagedObject+FetchRequest.m
//  Pods
//
//  Created by Aziz U. Latypov on 3/3/15.
//
//

#import "NSManagedObject+FetchRequest.h"
#import "ALCoreDataManager+Singleton.h"
#import "NSManagedObject+Helper.h"
#import "ALFetchRequest.h"

@implementation NSManagedObject (FetchRequest)

+ (ALFetchRequest*)fetchRequestInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext

{
	ALFetchRequest *fetchRequest = [[ALFetchRequest alloc] init];
	fetchRequest.managedObjectContext = managedObjectContext;
	NSEntityDescription *entity = [self entityDescriptionWithMangedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	return fetchRequest;
}

+ (ALFetchRequest*)fetchRequest
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self fetchRequestInManagedObjectContext:managedObjectContext];
}

@end
