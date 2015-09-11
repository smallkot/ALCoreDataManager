//
//  ALFetchRequest+DataSource.m
//  Pods
//
//  Created by Aziz Latypov on 8/23/15.
//
//

#import "ALFetchRequest+DataSource.h"
#import "ALDataSourceWithFetchedResultsController.h"

@implementation ALFetchRequest (DataSource)

- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource
{
    ALDataSourceWithFetchedResultsController *realDataSource =
    [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:[self request] managedObjectContext:self.managedObjectContext];
    return [realDataSource tableViewDataSource];
}

- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource
{
    ALDataSourceWithFetchedResultsController *realDataSource =
    [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:[self request] managedObjectContext:self.managedObjectContext];
    return [realDataSource collectionViewDataSource];
}

- (ALPickerViewDataSourceWithFetchedResultsController*)pickerViewDataSource
{
    ALDataSourceWithFetchedResultsController *realDataSource =
    [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:[self request] managedObjectContext:self.managedObjectContext];
    return [realDataSource pickerViewDataSource];
}

@end
