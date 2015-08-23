//
//  SPTableViewDataSource.m
//  surveypro
//
//  Created by Aziz U. Latypov on 7/8/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALTableViewDataSourceWithFetchedResultsController.h"

@interface ALTableViewDataSourceWithFetchedResultsController () <NSFetchedResultsControllerDelegate>

// dependencies
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// fetched results controller
@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation ALTableViewDataSourceWithFetchedResultsController

@synthesize fetchResultsController = _fetchResultsController;

-(instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext
             cellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
             andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock
{
    if (self = [super initWithCellConfigurationBlock:cellConfigurationBlock
                              andReuseIdentiferBlock:reuseIdentifierBlock]) {
        self.fetchRequest = fetchRequest;
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

#pragma mark - Predicate - 

- (void)setPredicate:(NSPredicate*)predicate
{
    self.fetchResultsController.fetchRequest.predicate = predicate;
    NSError *error;
    if(![self.fetchResultsController performFetch:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}

- (NSPredicate *)predicate
{
    return self.fetchResultsController.fetchRequest.predicate;
}

#pragma mark - Object At IndexPath -

- (NSInteger)itemsCount
{
    return [[[[self.fetchResultsController sections] firstObject] objects] count];
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForItem:(id)item
{
    return [self.fetchResultsController indexPathForObject:item];
}

#pragma mark - Fetch Request -

- (NSFetchedResultsController*)fetchResultsController
{
    if (!_fetchResultsController) {
        _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                      managedObjectContext:self.managedObjectContext
                                                                        sectionNameKeyPath:nil
                                                                                 cacheName:nil];
        _fetchResultsController.delegate = self;
        
        NSError *error = nil;
        if(![_fetchResultsController performFetch:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _fetchResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate -

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                     withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
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
            [self configureCell:(UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            
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
    UITableView *tableView = self.tableView;
    [tableView endUpdates];
}

@end
