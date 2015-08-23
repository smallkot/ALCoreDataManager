//
//  ALTableViewController.m
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 3/15/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ALCoreDataManager/ALCoreData.h>

#import "Product.h"

#import "ALProductsTableViewController.h"
#import "ALProductInfoTableViewController.h"

static NSString *const UpdateFinishedNotification = @"UpdateFinished";
static NSString *const TableViewCellReuseIdentifier = @"Cell";
static const NSInteger ALAlertViewTagAdd = 100;

static NSString *const SegueIdentifierForProductInfo = @"Segue";

static NSString *const kTitle = @"title";
static NSString *const kPrice = @"price";
static NSString *const kAmount = @"amount";

@interface ALProductsTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) ALTableViewDataSourceWithFetchedResultsController *dataSource;
- (Product*)productAtIndexPath:(NSIndexPath*)indexPath;

@end

@implementation ALProductsTableViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = [[[Product all] orderedBy:@[kTitle, kPrice]] tableViewDataSource];
    __weak typeof(self) weakSelf = self;
    self.dataSource.cellConfigurationBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath){
        [weakSelf configureCell:cell atIndexPath:indexPath];
    };
    self.dataSource.reuseIdentifierBlock = ^(NSIndexPath *indexPath){
        return TableViewCellReuseIdentifier;
    };
    self.dataSource.tableView = self.tableView;
}

#pragma mark - TableView DataSource and Delegate

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Product *item = [self productAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [item.price stringValue];
}

- (Product*)productAtIndexPath:(NSIndexPath*)indexPath
{
    return (Product *)[self.dataSource itemAtIndexPath:indexPath];
}

#pragma mark - Actions -

#pragma mark Add

- (IBAction)actionAdd:(id)sender
{
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD", @"")
                               message:NSLocalizedString(@"Add product with Title", @"")
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
                [Product createWithFields:@{
                                            kTitle : title,
                                            kPrice : @(0),
                                            kAmount : @(0)
                                            }
                             usingFactory:[ALManagedObjectFactory defaultFactory]];
            }
        }
    }
}

#pragma mark Statistics

- (IBAction)actionStats:(id)sender
{
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"STATISTICS", @"")
                                delegate:self
                       cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                  destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Total Amount", @""), NSLocalizedString(@"Average Price", @""),
     nil];
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    ALFetchRequest *request = nil;
    switch (buttonIndex) {
        case 0:
            request = [[Product all] aggregatedBy:@[@[kAggregatorSum, kAmount]]];
            break;
            

        case 1:
            request = [[Product all] aggregatedBy:@[@[kAggregatorAverage, kPrice]]];
            break;
            
        default:
            break;
    }
    
    NSArray *result = [request execute];
    NSDictionary *d = [result firstObject];
    
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LOG", @"")
                               message:[NSString stringWithFormat:NSLocalizedString(@"Request: %@\nResult: %@", @""), request, d]
                              delegate:self
                     cancelButtonTitle:NSLocalizedString(@"Good", @"")
                     otherButtonTitles:nil];
    
    [alertView show];
}

#pragma mark - Segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueIdentifierForProductInfo]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Product *product = [self productAtIndexPath:indexPath];
            [(ALProductInfoTableViewController*)segue.destinationViewController setProduct:product];
        }
    }
}

@end
