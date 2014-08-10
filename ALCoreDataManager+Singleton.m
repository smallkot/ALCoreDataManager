//
//  ALCoreDataManager+Singleton.m
//  Pods
//
//  Created by Aziz U. Latypov on 8/10/14.
//
//

#import "ALCoreDataManager+Singleton.h"

static NSString *const DefaultCoreDataModelName = nil;

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

@end
