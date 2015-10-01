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

#import "ALAlertView.h"
#import "ALActionSheet.h"

static NSString *const UpdateFinishedNotification = @"UpdateFinished";

static NSString *const SegueIdentifierForProductInfo = @"Segue";

static NSString *const kTitle = @"title";
static NSString *const kPrice = @"price";
static NSString *const kAmount = @"amount";
static NSString *const kCountry = @"country";

@interface ALProductsTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>
@end

@implementation ALProductsTableViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak typeof(self) weakSelf = self;
    
    NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
    ALFetchRequest *request = [[Product all] orderedBy:@[kTitle, kPrice]];
    assert(request);
    ALDataSourceWithFetchedResultsController *realDataSource =
    [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:request
                                                      managedObjectContext:context];

    self.dataSource = [realDataSource tableViewDataSource];
    self.dataSource.cellConfigurationBlock = ^(UITableViewCell *cell, NSIndexPath *indexPath){
        Product *item = (Product *)[weakSelf.dataSource objectAtIndexPath:indexPath];
        cell.textLabel.text = item.title;
        cell.detailTextLabel.text = [item.price stringValue];
    };
    
    self.dataSource.reuseIdentifierBlock = ^(NSIndexPath *indexPath){
        return @"Cell";
    };
    
    self.dataSource.tableView = self.tableView;
}

#pragma mark - Actions -

#pragma mark Add

- (IBAction)actionAdd:(id)sender
{
    ALAlertView *alertView =
    [[ALAlertView alloc] initWithTitle:NSLocalizedString(@"ADD", @"")
                               message:NSLocalizedString(@"Add product with Title", @"")
                     cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                     otherButtonTitles:NSLocalizedString(@"Create", @""), nil];
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    
    alertView.clickedBlock = ^(ALAlertView *alertView, NSUInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSString *title = [[alertView textFieldAtIndex:0] text];
            if ([title length]) {
                [Product createWithFields:@{
                                            kTitle : title,
                                            kPrice : @(0),
                                            kAmount : @(0)
                                            }];
            }
        }
    };
    [alertView show];
}

#pragma mark Statistics

- (IBAction)actionStats:(id)sender
{
    ALActionSheet *actionSheet =
    [[ALActionSheet alloc] initWithTitle:NSLocalizedString(@"STATISTICS", @"")
                       cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                  destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Total Amount", @""), NSLocalizedString(@"Average Price", @""),
     nil];
    
    actionSheet.clickedBlock = ^(ALActionSheet *actionSheet, NSUInteger buttonIndex) {
        ALFetchRequest *request = nil;
        switch (buttonIndex) {
            case 1:
                request = [[Product all] aggregatedBy:@[@[kAggregatorSum, kAmount]]];
                break;
                
                
            case 2:
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
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(@"Good", @"")
                         otherButtonTitles:nil];
        
        [alertView show];
    };
    
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - Segue -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SegueIdentifierForProductInfo]) {
        if ([sender isKindOfClass:[UITableViewCell class]]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            Product *product = (Product *)[self.dataSource objectAtIndexPath:indexPath];
            [(ALProductInfoTableViewController*)segue.destinationViewController setProduct:product];
        }
    }
}

@end
