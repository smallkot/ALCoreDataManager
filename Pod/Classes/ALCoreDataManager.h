//
//  ALCoreDataManager.h
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 8/7/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectModel;
@class NSManagedObjectContext;
@class NSPersistentStoreCoordinator;

@interface ALCoreDataManager : NSObject

- (instancetype)initWithModelName:(NSString*)modelName;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
