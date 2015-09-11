//
//  ALCollectionViewDataSourceWithFetchedResultsController.m
//  MyMoney
//
//  Created by Aziz U. Latypov on 8/6/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALCollectionViewDataSourceWithFetchedResultsController.h"
#import "ALDataSourceWithFetchedResultsController.h"

@interface ALCollectionViewDataSourceWithFetchedResultsController () <ALDataSourceWithFetchedResultsControllerDelegate>
{
    NSMutableArray *_objectChanges; //for collection view
}
//@property (readonly) NSMutableArray *objectChanges; //for collection view
@property (nonatomic, strong) NSBlockOperation *blockOperation; //for collection view
@property (nonatomic) BOOL shouldReloadCollectionView; //for collection view

@end

@implementation ALCollectionViewDataSourceWithFetchedResultsController

-(instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource
               cellConfigurationBlock:(ALCollectionViewCellConfigurationBlock)cellConfigurationBlock
               andReuseIdentiferBlock:(ALCollectionViewCellReuseIdentiferBlock)reuseIdentifierBlock
{
    if (self = [super initWithCellConfigurationBlock:cellConfigurationBlock
                              andReuseIdentiferBlock:reuseIdentifierBlock])
    {
        self.realDataSource.delegate = self;
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
    [self.collectionView reloadData];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    self.shouldReloadCollectionView = NO;
    self.blockOperation = [[NSBlockOperation alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
            }];
            break;
        }
            
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
    __weak UICollectionView *collectionView = self.collectionView;
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            if ([self.collectionView numberOfSections] > 0) {
                if ([self.collectionView numberOfItemsInSection:indexPath.section] == 0) {
                    self.shouldReloadCollectionView = YES;
                } else {
                    [self.blockOperation addExecutionBlock:^{
                        [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
                    }];
                }
            } else {
                self.shouldReloadCollectionView = YES;
            }
            break;
        }
            
        case NSFetchedResultsChangeDelete: {
            if ([self.collectionView numberOfItemsInSection:indexPath.section] == 1) {
                self.shouldReloadCollectionView = YES;
            } else {
                [self.blockOperation addExecutionBlock:^{
                    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
                }];
            }
            break;
        }
            
        case NSFetchedResultsChangeUpdate: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView reloadItemsAtIndexPaths:@[indexPath]];
            }];
            break;
        }
            
        case NSFetchedResultsChangeMove: {
            [self.blockOperation addExecutionBlock:^{
                [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            }];
            break;
        }
            
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
    if (self.shouldReloadCollectionView) {
        [self.collectionView reloadData];
    } else {
        [self.collectionView performBatchUpdates:^{
            [self.blockOperation start];
        } completion:nil];
    }
}

@end
