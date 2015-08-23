//
//  ALFetchRequest+DataSource.m
//  Pods
//
//  Created by Aziz Latypov on 8/23/15.
//
//

#import "ALFetchRequest+DataSource.h"

@implementation ALFetchRequest (DataSource)

- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource
{
    ALTableViewDataSourceWithFetchedResultsController *dataSource =
    [[ALTableViewDataSourceWithFetchedResultsController alloc] initWithFetchRequest:[self request] managedObjectContext:self.managedObjectContext cellConfigurationBlock:nil andReuseIdentiferBlock:nil];
    return dataSource;
}

- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource
{
    ALCollectionViewDataSourceWithFetchedResultsController *dataSource =
    [[ALCollectionViewDataSourceWithFetchedResultsController alloc] initWithFetchRequest:[self request] managedObjectContext:self.managedObjectContext cellConfigurationBlock:nil andReuseIdentiferBlock:nil];
    return dataSource;
}

@end
