//
//  ALCoreDataManager+Singleton.h
//  Pods
//
//  Created by Aziz U. Latypov on 8/10/14.
//
//

#import "ALCoreDataManager.h"

@interface ALCoreDataManager (Singleton)

+ (void)setDefaultCoreDataModelName:(NSString*)modelName;
+ (instancetype)defaultManager;

+ (NSManagedObjectContext*)defaultContext;

@end