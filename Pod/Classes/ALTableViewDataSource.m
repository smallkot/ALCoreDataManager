//
//  SPTableViewDataSourceAbstract.m
//  surveypro
//
//  Created by Aziz U. Latypov on 7/21/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALTableViewDataSource.h"

@implementation ALTableViewDataSource

-(instancetype)initWithCellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
                       andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock
{
    if (self = [super init]) {
        self.cellConfigurationBlock = cellConfigurationBlock;
        self.reuseIdentifierBlock = reuseIdentifierBlock;
    }
    return self;
}

-(void)setTableView:(UITableView *)tableView
{
    _tableView = tableView;
    _tableView.dataSource = self;
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self itemsCount];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = self.reuseIdentifierBlock(indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    self.cellConfigurationBlock(cell, indexPath);
    
    return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    self.cellConfigurationBlock(cell, indexPath);
}

@end
