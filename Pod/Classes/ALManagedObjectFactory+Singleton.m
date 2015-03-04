//
//  ALManagedObjectFactory+Singleton.m
//  
//
//  Created by Aziz U. Latypov on 8/11/14.
//
//

#import "ALManagedObjectFactory+Singleton.h"
#import "ALCoreDataManager+Singleton.h"

@import CoreData;

@implementation ALManagedObjectFactory (Singleton)

+ (ALManagedObjectFactory*)defaultFactory
{
    static ALManagedObjectFactory *factory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
        factory =
        [[ALManagedObjectFactory alloc] initWithManagedObjectContext:managedObjectContext
                                           andEntityDescriptionClass:[NSEntityDescription class]];
    });
    return factory;
}

@end
