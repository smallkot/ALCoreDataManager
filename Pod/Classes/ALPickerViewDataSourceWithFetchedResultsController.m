//
//  ALPickerViewDataSourceWithFetchedResultsController.m
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import "ALPickerViewDataSourceWithFetchedResultsController.h"
#import "ALDataSourceWithFetchedResultsController.h"

@interface ALPickerViewDataSourceWithFetchedResultsController () <ALDataSourceWithFetchedResultsControllerDelegate>

@end

@implementation ALPickerViewDataSourceWithFetchedResultsController

- (instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource
{
    if (self = [super init])
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
@end
