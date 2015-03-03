#import "ALCoreDataManager.h"

@import CoreData;

@interface ALCoreDataManager ()

@property (strong, nonatomic) NSString *modelName;
@property (readonly) NSURL *modelURL;
@property (readonly) NSURL *storeURL;

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSOperationQueue *notificationQueue;

@end

@implementation ALCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (instancetype)initWithModelName:(NSString*)modelName
{
    self = [super init];
    if (self) {
        self.modelName = modelName;
    }
    return self;
}

#pragma - Block -

- (NSOperationQueue *)operationQueue
{
	if (!_operationQueue) {
		_operationQueue = [[NSOperationQueue alloc] init];
		_operationQueue.name = @"ALCoreDataManager Concurrent Queue";
		_operationQueue.maxConcurrentOperationCount = 3;
	}
	return _operationQueue;
}

- (NSOperationQueue *)notificationQueue
{
	if (!_notificationQueue) {
		_notificationQueue = [[NSOperationQueue alloc] init];
		_notificationQueue.name = @"ALCoreDataManager Notification Handling Queue";
		_notificationQueue.maxConcurrentOperationCount = 1;
	}
	return _notificationQueue;
}

- (NSManagedObjectContext*)newContext
{
	NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
	context.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
	return context;
}

- (void)performBlock:(void(^)(NSManagedObjectContext *localContext))block
 andEmitNotification:(NSString *)notificationName;
{
	__weak ALCoreDataManager *weakSelf = self;
	
	NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
		
		NSManagedObjectContext *localContext = [weakSelf newContext];
		
		[[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
														  object:localContext
														   queue:weakSelf.notificationQueue
													  usingBlock:^(NSNotification *notification)
		 {
			 [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
			 
			 // emit
			 if (notificationName.length) {
				 [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
																	 object:nil];
			 }
		 }];
		
		block(localContext);
		
		if ([localContext hasChanges]) {
			NSError *error = nil;
			[localContext save:&error];
		}
		
	}];
	
	[self.operationQueue addOperation:operation];
}

#pragma mark - Helpers

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)modelURL{
    return [[NSBundle mainBundle] URLForResource:self.modelName withExtension:@"momd"];
}

- (NSURL*)storeURL{
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.modelName]];
}

#pragma mark - Main

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        NSError *error = nil;
        
#ifdef DEBUG
        int numberOfTries = 0;
try_again:
#endif
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:self.storeURL
                                                             options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
                                                               error:&error]) {
#ifdef DEBUG
            [[NSFileManager defaultManager] removeItemAtURL:self.storeURL error:nil];
            if (numberOfTries < 1) {
                numberOfTries++;
                goto try_again;
            }
#endif
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

@end
