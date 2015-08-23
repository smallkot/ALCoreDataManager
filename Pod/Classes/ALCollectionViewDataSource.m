//
//  ALCollectionViewDataSource.m
//  MyMoney
//
//  Created by Aziz U. Latypov on 8/6/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALCollectionViewDataSource.h"

@implementation ALCollectionViewDataSource

-(instancetype)initWithCellConfigurationBlock:(ALCollectionViewCellConfigurationBlock)cellConfigurationBlock
                       andReuseIdentiferBlock:(ALCollectionViewCellReuseIdentiferBlock)reuseIdentifierBlock
{
    if (self = [super init]) {
        self.cellConfigurationBlock = cellConfigurationBlock;
        self.reuseIdentifierBlock = reuseIdentifierBlock;
    }
    return self;
}

-(void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    _collectionView.dataSource = self;
}

#pragma mark - Abstract Methods -

-(NSInteger)itemsCount
{
    return 0;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionViewDataSource -

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self itemsCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = self.reuseIdentifierBlock(indexPath);
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier
                                                                           forIndexPath:indexPath];
    
    self.cellConfigurationBlock(cell, indexPath);
    
    return cell;
}

- (void)configureCell:(UICollectionViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    self.cellConfigurationBlock(cell, indexPath);
}

@end
