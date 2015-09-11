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

#import "ALDataSourceWithFetchedResultsController.h"
#import "ALTableViewDataSourceWithFetchedResultsController.h"
#import "ALCollectionViewDataSourceWithFetchedResultsController.h"
#import "ALPickerViewDataSourceWithFetchedResultsController.h"

@interface ALFetchRequest (DataSource)

/**
 Creates a UITableViewDataSource object for your tableView from request built by query builder.
 
 @returns A tableView DataSource with NSFetchedResultsController inside.
 
 @param managedObjectContext Context for fetch request.
 
 @code
 ALTableViewDataSource *dataSource =
 [[[Product all] orderedBy:@[@"title", @"price"]] tableViewDataSource];
 
 __weak typeof(self) weakSelf = self;
 dataSource.cellConfigurationBlock = void(^)(UITableViewCell *cell, NSIndexPath *indexPath){
     [weakSelf configureCell:cell atIndexPath:indexPath];
 };
 
 dataSource.reuseIdentifierBlock = NSString*(^)(NSIndexPath *indexPath){
     return @"Cell";
 };
 
 self.dataSource.tableView = self.tableView;
 @endcode
 */
- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource;


/**
 Creates a data source for your collectionView with request build by query builder.
 
 @returns A collectionView DataSource with NSFetchedResultsController inside.
 
 @code
 ALCollectionViewDataSourceWithFetchedResultsController *dataSource =
 [[[Product allInManagedObjectContext:context] orderedBy:@[@"price"]] collectionViewDataSource];
 
 dataSource.collectionView = self.collectionView;
 @endcode
 */
- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource;

/**
 Creates a data source for your pickerView with request build by query builder.
 
 @returns A pickerView DataSource with NSFetchedResultsController inside.
 
 @code
 ALPickerViewDataSourceWithFetchedResultsController *dataSource =
 [[[Product allInManagedObjectContext:context] orderedBy:@[@"price"]] pickerViewDataSource];
 
 dataSource.pickerView = self.pickerView;
 @endcode
 */
- (ALPickerViewDataSourceWithFetchedResultsController*)pickerViewDataSource;

@end
