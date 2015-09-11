//
//  ALSelectContryTableViewCell.m
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import "ALSelectContryTableViewCell.h"
#import "RMPickerViewController.h"

#import <CoreData/CoreData.h>
#import <ALCoreDataManager/ALCoreData.h>

#import "Country.h"

#import "ALProductsTableViewController.h"
#import "ALProductInfoTableViewController.h"

@interface ALSelectContryTableViewCell () <UITextFieldDelegate>
@property (strong, nonatomic) ALPickerViewDataSourceWithFetchedResultsController *dataSource;
@end

@implementation ALSelectContryTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.textField.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    RMPickerViewController *pickerController = [RMPickerViewController pickerController];

    NSManagedObjectContext *context = [ALCoreDataManager defaultManager].managedObjectContext;
    ALFetchRequest *request = [[Country all] orderedBy:@[@"name"]];
    assert(request);
    ALDataSourceWithFetchedResultsController *realDataSource =
    [[ALDataSourceWithFetchedResultsController alloc] initWithFetchRequest:request
                                                      managedObjectContext:context];
    
    self.dataSource = [realDataSource pickerViewDataSource];
    
    self.dataSource.pickerView = pickerController.picker;

    
    return NO;
}

@end
