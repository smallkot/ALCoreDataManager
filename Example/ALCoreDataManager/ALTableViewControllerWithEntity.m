//
//  ALTableViewControllerWithEntity.m
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import "ALTableViewControllerWithEntity.h"

#import <CoreData/CoreData.h>
#import <ALCoreDataManager/ALCoreData.h>

#import <ALCoreDataManager/ALFetchRequest+QueryBuilder.h>

static NSString *const CellReuseIdentifierForCell = @"Cell"; // Default Cell Reuse Identifier


static const NSInteger ALAlertViewTagAdd = 100;

@interface ALTableViewControllerWithEntity () <UIAlertViewDelegate>

@end

@implementation ALTableViewControllerWithEntity

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource.tableView = self.tableView;
}

- (ALTableViewDataSourceWithFetchedResultsController *)dataSource
{
    if (!_dataSource) {
        __weak typeof(self) weakSelf = self;
        ALTableViewCellConfigurationBlock configurationBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath){
            [weakSelf configureCell:cell atIndexPath:indexPath];
        };
        ALTableViewCellReuseIdentiferBlock reuseIdentiferBlock = ^(NSIndexPath *indexPath){
            if ([self.cellReuseIdentifier length]) {
                return self.cellReuseIdentifier;
            }
            return CellReuseIdentifierForCell;
        };
        NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
        Class itemsClass = NSClassFromString(self.entityClassName);
        NSString *titlePath = self.titlePath;
        ALFetchRequest *request = [[itemsClass all] orderedBy:@[titlePath]];
        assert(request);
        ALDataSourceWithFetchedResultsController *realDataSource =
        [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:request
                                                          managedObjectContext:context];

        self.dataSource = [realDataSource tableViewDataSource];
        self.dataSource.cellConfigurationBlock = configurationBlock;
        self.dataSource.reuseIdentifierBlock = reuseIdentiferBlock;
    }
    return _dataSource;
}

#pragma mark - TableView DataSource and Delegate
    
- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    id item = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = [item valueForKey:self.titlePath];
}

- (IBAction)actionAdd:(id)sender
{
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD", @"")
                               message:NSLocalizedString(@"Title", @"")
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                     otherButtonTitles:NSLocalizedString(@"Create", @""), nil];
    alertView.tag = ALAlertViewTagAdd;
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == ALAlertViewTagAdd) {
        if (buttonIndex > 0) {
            NSString *title = [[alertView textFieldAtIndex:0] text];
            if ([title length]) {
                
                Class itemsClass = NSClassFromString(self.entityClassName);
                NSString *titlePath = self.titlePath;

                id item =
                [itemsClass createWithFields:@{
                                            titlePath : title,
                                            }
                             usingFactory:[ALManagedObjectFactory defaultFactory]];

                NSLog(@"%@",item);
            }
        }
    }
}


@end
