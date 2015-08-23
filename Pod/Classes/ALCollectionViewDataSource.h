//
//  ALCollectionViewDataSource.h
//  MyMoney
//
//  Created by Aziz U. Latypov on 8/6/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALDataSourceAbstract.h"

typedef void(^ALCollectionViewCellConfigurationBlock)(UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef NSString*(^ALCollectionViewCellReuseIdentiferBlock)(NSIndexPath *indexPath);

@interface ALCollectionViewDataSource : ALDataSourceAbstract <UICollectionViewDataSource>

@property (copy, nonatomic) ALCollectionViewCellConfigurationBlock cellConfigurationBlock;
@property (copy, nonatomic) ALCollectionViewCellReuseIdentiferBlock reuseIdentifierBlock;

// dependencies
@property (strong, nonatomic) UICollectionView *collectionView;

- (instancetype)initWithCellConfigurationBlock:(ALCollectionViewCellConfigurationBlock)cellConfigurationBlock
                        andReuseIdentiferBlock:(ALCollectionViewCellReuseIdentiferBlock)reuseIdentifierBlock;

// public api
- (void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end
