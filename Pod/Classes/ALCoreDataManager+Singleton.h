//
//  ALCoreDataManager+Singleton.h
//  Pods
//
//  Created by Aziz U. Latypov on 8/10/14.
//
//

#import "ALCoreDataManager.h"
#import "NSManagedObject+Query.h"

@interface ALCoreDataManager (Singleton)

+ (void)setDefaultCoreDataModelName:(NSString*)modelName;
+ (instancetype)defaultManager;

@end