//
//  ALTableViewController.m
//  ALCoreDataManager
//
//  Created by Aziz U. Latypov on 3/15/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ALCoreDataManager/ALCoreData.h>

#import "ALProductsTableViewController.h"
#import "Product.h"

#import "ALProductInfoTableViewController.h"

static NSString *const UpdateFinishedNotification = @"UpdateFinished";
static NSString *const TableViewCellReuseIdentifier = @"Cell";
static const NSInteger ALAlertViewTagAdd = 100;

static NSString *const SegueIdentifierForProductInfo = @"Segue";

static NSString *const kTitle = @"title";
static NSString *const kPrice = @"price";
static NSString *const kAmount = @"amount";

typedef enum : NSUInteger {
    ALStatsTypeTotalAmount,
    ALStatsTypeMedianPrice,
} ALStatsType;

@interface ALProductsTableViewController () <NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIRefreshControl *activityIndicator;

@property (strong, nonatomic) ALManagedObjectFactory *factory;
@property (strong, nonatomic) NSFetchedResultsController *controller;

- (Product*)productAtIndexPath:(NSIndexPath*)indexPath;

@end

@implementation ALProductsTableViewController

#pragma mark - View Lifecycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
    NSFetchRequest *request = [[[Product all] orderedBy:@[kTitle, kPrice]] request];
    
    self.controller =
    [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                        managedObjectContext:context
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.controller.delegate = self;
    [self.controller performFetch:nil];
}

#pragma mark - TableView DataSource and Delegate

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [[[[self.controller sections] firstObject] objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell =
	[self.tableView dequeueReusableCellWithIdentifier:TableViewCellReuseIdentifier
										 forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    Product *item = [self productAtIndexPath:indexPath];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = [item.price stringValue];
}

#pragma mark - Actions -

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

- (IBAction)actionEdit:(id)sender
{
    [self setEditing:!self.editing animated:YES];
    self.navigationItem.leftBarButtonItem.style = self.editing ? UIBarButtonItemStyleDone : UIBarButtonSystemItemEdit;
}

- (IBAction)actionDeleteAll:(id)sender
{
    [[[[self.controller sections] firstObject] objects]
     makeObjectsPerformSelector:@selector(remove)];
}

- (IBAction)actionRefresh:(id)sender
{
	[[ALCoreDataManager defaultManager] saveAfterPerformingBlock:^(NSManagedObjectContext *localContext) {
		
		int i;
		ALManagedObjectFactory *factory =
		[[ALManagedObjectFactory alloc] initWithManagedObjectContext:localContext];
		
		for(i=0; i<18; i++){
			Product *a = (Product*)[Product createWithFields:nil
									           usingFactory:factory];
			
			a.title = [NSString stringWithFormat:@"%c",'A'+i];
			a.price = @(100 + (rand()%10));
			a.amount = @(10 + (rand()%10));
		}
		
	} withCompletionHandler:^{
		[self.activityIndicator endRefreshing];
	}];
}

- (IBAction)actionStats:(id)sender
{
    UIActionSheet *actionSheet =
    [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"STATISTICS", @"")
                                delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                  destructiveButtonTitle:nil
                       otherButtonTitles:NSLocalizedString(@"Total Amount", @""), NSLocalizedString(@"Average Price", @""),
     nil];
    [actionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    ALStatsType st = buttonIndex;
    ALFetchRequest *request = nil;
    switch (st) {
        case ALStatsTypeTotalAmount:
            request = [[Product all] aggregatedBy:@[@[kAggregatorSum, kAmount]]];
            break;
            

        case ALStatsTypeMedianPrice:
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

#pragma mark - UIAlertViewDelegate -

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
                             usingFactory:self.factory];
            }
        }
    }
}

#pragma mark - Lazy Properties -

- (ALManagedObjectFactory *)factory
{
    if (!_factory) {
        NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
        _factory =
        [[ALManagedObjectFactory alloc] initWithManagedObjectContext:context];
    }
    return _factory;
}

- (Product*)productAtIndexPath:(NSIndexPath*)indexPath
{
    return (Product *)[self.controller objectAtIndexPath:indexPath];
}

#pragma mark - NSFetchedResultsControllerDelegate -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
