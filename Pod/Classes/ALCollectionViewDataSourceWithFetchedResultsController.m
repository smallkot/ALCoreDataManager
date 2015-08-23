//
//  ALCollectionViewDataSourceWithFetchedResultsController.m
//  MyMoney
//
//  Created by Aziz U. Latypov on 8/6/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import "ALCollectionViewDataSourceWithFetchedResultsController.h"

@interface ALCollectionViewDataSourceWithFetchedResultsController () <NSFetchedResultsControllerDelegate>
{
    NSMutableArray *_objectChanges; //for collection view
}
//@property (readonly) NSMutableArray *objectChanges; //for collection view
@property (nonatomic, strong) NSBlockOperation *blockOperation; //for collection view
@property (nonatomic) BOOL shouldReloadCollectionView; //for collection view

@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// fetched results controller
@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation ALCollectionViewDataSourceWithFetchedResultsController
@synthesize fetchResultsController = _fetchResultsController;

-(instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext
             cellConfigurationBlock:(ALCollectionViewCellConfigurationBlock)cellConfigurationBlock
             andReuseIdentiferBlock:(ALCollectionViewCellReuseIdentiferBlock)reuseIdentifierBlock
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
    [self.collectionView reloadData];
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

#pragma mark - Delete -

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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
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
