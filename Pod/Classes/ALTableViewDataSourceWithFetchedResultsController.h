//
//  SPTableViewDataSource.h
//  surveypro
//
//  Created by Aziz U. Latypov on 7/8/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "ALTableViewDataSource.h"

@class ALDataSourceWithFetchedResultsController;

@interface ALTableViewDataSourceWithFetchedResultsController : ALTableViewDataSource

@property (strong, nonatomic) ALDataSourceWithFetchedResultsController *realDataSource;

- (instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource
                cellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
                andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock;

@end
