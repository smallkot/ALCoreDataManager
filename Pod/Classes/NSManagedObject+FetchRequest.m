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

+ (ALFetchRequest*)allInManagedObjectContext:(NSManagedObjectContext*)managedObjectContext

{
	ALFetchRequest *fetchRequest = [[ALFetchRequest alloc] init];
	fetchRequest.managedObjectContext = managedObjectContext;
	NSEntityDescription *entity = [self entityDescriptionWithMangedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setIncludesPendingChanges:YES];
	
	return fetchRequest;
}

+ (ALFetchRequest*)all
{
	NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
	return [self allInManagedObjectContext:managedObjectContext];
}

@end
