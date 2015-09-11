//
//  ALCollectionViewDataSourceWithFetchedResultsController.h
//  MyMoney
//
//  Created by Aziz U. Latypov on 8/6/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALCollectionViewDataSource.h"

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ALDataSourceWithFetchedResultsController;

@interface ALCollectionViewDataSourceWithFetchedResultsController : ALCollectionViewDataSource

@property (strong, nonatomic) ALDataSourceWithFetchedResultsController *realDataSource;

-(instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource
               cellConfigurationBlock:(ALCollectionViewCellConfigurationBlock)cellConfigurationBlock
               andReuseIdentiferBlock:(ALCollectionViewCellReuseIdentiferBlock)reuseIdentifierBlock;

@end
