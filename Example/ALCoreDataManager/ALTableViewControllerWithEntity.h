//
//  ALTableViewControllerWithEntity.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ALCoreDataManager/ALTableViewDataSourceWithFetchedResultsController.h>

@interface ALTableViewControllerWithEntity : UITableViewController

@property (strong, nonatomic) NSString *entityClassName;
@property (strong, nonatomic) NSString *titlePath;
@property (strong, nonatomic) NSString *cellReuseIdentifier;

@property (strong, nonatomic) ALTableViewDataSourceWithFetchedResultsController *dataSource;

- (IBAction)actionAdd:(id)sender;

@end
