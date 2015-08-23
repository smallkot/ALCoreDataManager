//
//  SPTableViewDataSourceAbstract.h
//  surveypro
//
//  Created by Aziz U. Latypov on 7/21/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALDataSourceAbstract.h"

typedef void(^ALTableViewCellConfigurationBlock)(UITableViewCell *cell, NSIndexPath *indexPath);
typedef NSString*(^ALTableViewCellReuseIdentiferBlock)(NSIndexPath *indexPath);

@interface ALTableViewDataSource : ALDataSourceAbstract <UITableViewDataSource>

@property (copy, nonatomic) ALTableViewCellConfigurationBlock cellConfigurationBlock;
@property (copy, nonatomic) ALTableViewCellReuseIdentiferBlock reuseIdentifierBlock;

// dependencies
@property (strong, nonatomic) UITableView *tableView;

- (instancetype)initWithCellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
                        andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock;

// public api
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end