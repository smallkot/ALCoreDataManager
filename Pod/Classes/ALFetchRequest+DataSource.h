//
//  ALFetchRequest+DataSource.h
//  Pods
//
//  Created by Aziz Latypov on 8/23/15.
//
//

#import <CoreData/CoreData.h>
#import "NSManagedObject+FetchRequest.h"
#import "ALFetchRequest.h"
#import "ALFetchRequest+QueryBuilder.h"

#import "ALTableViewDataSourceWithFetchedResultsController.h"
#import "ALCollectionViewDataSourceWithFetchedResultsController.h"

@interface ALFetchRequest (DataSource)

/**
 Crates a UITableViewDataSource object for your tableView from request built by query builder.
 
 @returns A tableView DataSource with NSFetchedResultsController inside.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 ALTableViewDataSource *dataSource =
 [[[Product all] orderedBy:@[kTitle, kPrice]] tableViewDataSource];
 
 __weak typeof(self) weakSelf = self;
 dataSource.cellConfigurationBlock = void(^)(UITableViewCell *cell, NSIndexPath *indexPath){
     [weakSelf configureCell:cell atIndexPath:indexPath];
 };
 
 dataSource.reuseIdentifierBlock = NSString*(^)(NSIndexPath *indexPath){
     return TableViewCellReuseIdentifier;
 };
 
 self.dataSource.tableView = self.tableView;
 @endcode
 */
- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource;


/**
 Crate a data source for your collectionView with request build by query builder.
 
 @returns A collectionView DataSource with NSFetchedResultsController inside.
 
 @code
 ALCollectionViewDataSourceWithFetchedResultsController *dataSource =
 [[[Product allInManagedObjectContext:context] orderedBy:@[@"price"]] collectionViewDataSource];
 
 dataSource.collectionView = self.tableView;
 @endcode
 */
- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource;

@end
