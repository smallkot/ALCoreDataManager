//
//  ALPickerViewDataSourceWithFetchedResultsController.h
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import "ALPickerViewDataSource.h"

@class ALDataSourceWithFetchedResultsController;

@interface ALPickerViewDataSourceWithFetchedResultsController : ALPickerViewDataSource

@property (strong, nonatomic) ALDataSourceWithFetchedResultsController *realDataSource;

- (instancetype)initWithRealDataSource:(ALDataSourceWithFetchedResultsController*)realDataSource;

@end
