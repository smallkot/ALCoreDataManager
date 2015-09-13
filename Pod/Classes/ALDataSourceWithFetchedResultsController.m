//
//  ALDataSourceWithFetchedResultsController.m
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import "ALDataSourceWithFetchedResultsController.h"

#import "ALTableViewDataSourceWithFetchedResultsController.h"
#import "ALCollectionViewDataSourceWithFetchedResultsController.h"
#import "ALPickerViewDataSourceWithFetchedResultsController.h"

@interface ALDataSourceWithFetchedResultsController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation ALDataSourceWithFetchedResultsController

- (instancetype)initWithFetchRequest:(NSFetchRequest*)fetchRequest
                managedObjectContext:(NSManagedObjectContext*)managedObjectContext
                  sectionNameKeyPath:(NSString *)sectionNameKeyPath
                           cacheName:(NSString *)cacheName
{
    if (self = [super init]) {
        self.fetchRequest = fetchRequest;
        self.managedObjectContext = managedObjectContext;
        self.sectionNameKeyPath = sectionNameKeyPath;
        self.cacheName = cacheName;
    }
    return self;
}

-(instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    return [self initWithFetchRequest:fetchRequest
                 managedObjectContext:managedObjectContext
                   sectionNameKeyPath:nil
                            cacheName:nil];
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

    if ([self.delegate respondsToSelector:@selector(reloadDataWithDataSourceWithFetchedResultsController:)]) {
        [self.delegate reloadDataWithDataSourceWithFetchedResultsController:self];
    }
}

- (NSPredicate *)predicate
{
    return self.fetchResultsController.fetchRequest.predicate;
}

#pragma mark - Object At IndexPath -

- (NSInteger)numberOfSections
{
    return [[self.fetchResultsController sections] count];
}

- (NSInteger)numberOfObjectsInSection:(NSInteger)sectionIndex
{
    return [[[[self.fetchResultsController sections] objectAtIndex:sectionIndex] objects] count];
}

- (id<ALDataSourceAbstractSectionItem>)sectionAtIndex:(NSInteger)sectionIndex
{
    return [[self.fetchResultsController sections] objectAtIndex:sectionIndex];
}

- (id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    return [self.fetchResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object
{
    return [self.fetchResultsController indexPathForObject:object];
}

#pragma mark - Fetch Request -

- (NSFetchedResultsController*)fetchResultsController
{
    if (!_fetchResultsController) {
        _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
                                                                      managedObjectContext:self.managedObjectContext
                                                                        sectionNameKeyPath:self.sectionNameKeyPath
                                                                                 cacheName:self.cacheName];
        
        _fetchResultsController.delegate = self.delegate;

        NSError *error = nil;
        if(![_fetchResultsController performFetch:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _fetchResultsController;
}

- (void)setDelegate:(id<ALDataSourceWithFetchedResultsControllerDelegate>)delegate
{
    _delegate = delegate;
    self.fetchResultsController.delegate = _delegate;
}

@end

@implementation ALDataSourceWithFetchedResultsController (TableViewDataSource)
- (ALTableViewDataSourceWithFetchedResultsController*)tableViewDataSource
{
    return [[ALTableViewDataSourceWithFetchedResultsController alloc] initWithRealDataSource:self cellConfigurationBlock:nil andReuseIdentiferBlock:nil];
}
@end

@implementation ALDataSourceWithFetchedResultsController (CollectionViewDataSource)
- (ALCollectionViewDataSourceWithFetchedResultsController*)collectionViewDataSource
{
    return [[ALCollectionViewDataSourceWithFetchedResultsController alloc] initWithRealDataSource:self cellConfigurationBlock:nil andReuseIdentiferBlock:nil];
}
@end

@implementation ALDataSourceWithFetchedResultsController (PickerViewDataSource)
- (ALPickerViewDataSourceWithFetchedResultsController*)pickerViewDataSource
{
    return [[ALPickerViewDataSourceWithFetchedResultsController alloc] initWithRealDataSource:self];
}
@end

