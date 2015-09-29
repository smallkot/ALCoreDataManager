//
//  ALDataSourceWithFetchedResultsController.h
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import "ALDataSourceAbstract.h"

#import <CoreData/CoreData.h>

@class ALDataSourceWithFetchedResultsController;

@class ALTableViewDataSourceWithFetchedResultsController;
@class ALCollectionViewDataSourceWithFetchedResultsController;
@class ALPickerViewDataSourceWithFetchedResultsController;

@protocol ALDataSourceWithFetchedResultsControllerDelegate <NSFetchedResultsControllerDelegate, NSObject>
@optional
- (void)reloadDataWithDataSourceWithFetchedResultsController:(ALDataSourceWithFetchedResultsController*)dataSourceWithFetchedResultsController;
@end

@interface ALDataSourceWithFetchedResultsController : ALDataSourceAbstract

@property (weak, nonatomic) id<ALDataSourceWithFetchedResultsControllerDelegate> delegate;

@property (nonatomic, readonly) NSFetchedResultsController *fetchResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSString *sectionNameKeyPath;
@property (strong, nonatomic) NSString *cacheName;

- (instancetype)initWithFetchRequest:(NSFetchRequest*)fetchRequest
                managedObjectContext:(NSManagedObjectContext*)managedObjectContext
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath
                           cacheName:(NSString *)cacheName NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
                managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (instancetype)init;

@end

/*
 * Adapters
 */

@interface ALDataSourceWithFetchedResultsController (TableViewDataSource)
- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource;
@end

@interface ALDataSourceWithFetchedResultsController (CollectionViewDataSource)
- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource;
@end

@interface ALDataSourceWithFetchedResultsController (PickerViewDataSource)
- (ALPickerViewDataSourceWithFetchedResultsController*)pickerViewDataSource;
@end