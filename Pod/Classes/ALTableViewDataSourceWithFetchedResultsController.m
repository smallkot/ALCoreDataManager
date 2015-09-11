//
//  SPTableViewDataSource.m
//  surveypro
//
//  Created by Aziz U. Latypov on 7/8/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALTableViewDataSourceWithFetchedResultsController.h"
#import "ALDataSourceWithFetchedResultsController.h"

@interface ALTableViewDataSourceWithFetchedResultsController () <ALDataSourceWithFetchedResultsControllerDelegate>

@end

@implementation ALTableViewDataSourceWithFetchedResultsController

- (instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource
                cellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
                andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock
{
    if (self = [super initWithCellConfigurationBlock:cellConfigurationBlock
                              andReuseIdentiferBlock:reuseIdentifierBlock])
    {
        self.realDataSource = realDataSource;
    }
    return self;
}

- (void)setRealDataSource:(ALDataSourceWithFetchedResultsController *)realDataSource
{
    _realDataSource = realDataSource;
    _realDataSource.delegate = self;
}

#pragma mark - Adapter -

- (void)setPredicate:(NSPredicate *)predicate {
    [self.realDataSource setPredicate:predicate];
}

- (NSPredicate *)predicate {
    return self.realDataSource.predicate;
}

- (NSInteger)numberOfSections {
    return [self.realDataSource numberOfSections];
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)sectionIndex {
    return [self.realDataSource numberOfObjectsInSection:sectionIndex];
}

- (id<ALDataSourceAbstractSectionItem>)sectionAtIndex:(NSInteger)sectionIndex {
    return [self.realDataSource sectionAtIndex:sectionIndex];
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath {
    return [self.realDataSource objectAtIndexPath:indexPath];
}

- (NSIndexPath*)indexPathForObject:(id)object {
    return [self.realDataSource indexPathForObject:object];
}

#pragma mark - NSFetchedResultsControllerDelegate -

- (void)reloadDataWithDataSourceWithFetchedResultsController:(ALDataSourceWithFetchedResultsController *)dataSourceWithFetchedResultsController
{
    [self.tableView reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
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
            
        default:
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = self.tableView;
    [tableView endUpdates];
}

@end
