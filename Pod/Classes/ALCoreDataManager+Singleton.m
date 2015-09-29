//
//  ALCoreDataManager+Singleton.m
//  Pods
//
//  Created by Aziz U. Latypov on 8/10/14.
//
//

#import "ALCoreDataManager+Singleton.h"

@import CoreData;

static NSString *DefaultCoreDataModelName = nil;

#pragma mark -

@implementation ALCoreDataManager (Singleton)

+ (void)setDefaultCoreDataModelName:(NSString*)modelName
{
    DefaultCoreDataModelName = modelName;
}

+ (instancetype)defaultManager {
    static ALCoreDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] initWithModelName:DefaultCoreDataModelName];
    });
    return _sharedInstance;
}

+ (NSManagedObjectContext *)defaultContext
{
	return [ALCoreDataManager defaultManager].managedObjectContext;
}

@end

#pragma mark - Factory -

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

#pragma mark - Fetch - 

@implementation NSManagedObject (FetchRequestSingleton)

+ (ALFetchRequest*)all
{
    NSManagedObjectContext *managedObjectContext = [ALCoreDataManager defaultManager].managedObjectContext;
    return [self allInManagedObjectContext:managedObjectContext];
}

+ (ALFetchRequest*)fetch 
{
    return [self all];
}

@end

#pragma mark - Create -

@implementation NSManagedObject (CreateSingleton)

+ (NSManagedObject*)createWithFields:(NSDictionary*)fields
{
    ALManagedObjectFactory *factory = [ALManagedObjectFactory defaultFactory];
    return [self createWithFields:fields
                     usingFactory:factory];
}

+ (NSManagedObject *)create
{
    return [self createWithFields:nil];
}

@end
