//
//  ALTableViewController.h
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 3/15/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ALProductsTableViewController : UITableViewController

// dependencies
@property (strong, nonatomic) ALTableViewDataSource *dataSource;

@end
