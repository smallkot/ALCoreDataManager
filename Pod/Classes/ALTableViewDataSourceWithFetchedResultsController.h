//
//  SPTableViewDataSource.h
//  surveypro
//
//  Created by Aziz U. Latypov on 7/8/14.
//  Copyright (c) 2014 Aziz U. Latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "ALTableViewDataSource.h"

@interface ALTableViewDataSourceWithFetchedResultsController : ALTableViewDataSource

- (instancetype)initWithFetchRequest:(NSFetchRequest*)fetchRequest
                managedObjectContext:(NSManagedObjectContext*)managedObjectContext
              cellConfigurationBlock:(ALTableViewCellConfigurationBlock)cellConfigurationBlock
              andReuseIdentiferBlock:(ALTableViewCellReuseIdentiferBlock)reuseIdentifierBlock;

@end
