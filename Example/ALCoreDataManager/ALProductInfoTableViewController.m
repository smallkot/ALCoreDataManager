//
//  ALProductInfoTableViewController.m
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 8/22/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import "ALProductInfoTableViewController.h"

#import "Product.h"
#import "Country.h"

#import "ALTextEditTableViewCell.h"
#import "ALSelectContryTableViewCell.h"

#import <ALCoreDataManager/ALCoreData.h>

static NSString *const CellReuseIdentifierForALTextEditTableViewCell = @"ALTextEditTableViewCell";


@interface ALProductInfoTableViewController () <UIAlertViewDelegate>

@end

@implementation ALProductInfoTableViewController

#pragma mark - ViewController Lifecycle -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateUI];
}

#pragma mark - TableView DataSource and Deleget -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"TITLE", @"");
            break;
            
        case 1:
            title = NSLocalizedString(@"PRICE", @"");
            break;
            
        case 2:
            title = NSLocalizedString(@"AMOUNT", @"");
            break;
            
        case 3:
            title = NSLocalizedString(@"COUNTRY", @"");
            break;
            
        default:
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALTextEditTableViewCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:CellReuseIdentifierForALTextEditTableViewCell
                                         forIndexPath:indexPath];
    return cell;
}

#pragma mark - UI Update -

- (void)setProduct:(Product *)product
{
    _product = product;
    [self updateUI];
}

- (void)updateUI
{
    ALTextEditTableViewCell *titleCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ALTextEditTableViewCell *priceCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ALTextEditTableViewCell *amountCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    ALSelectContryTableViewCell *countryCell = (ALSelectContryTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    
    titleCell.textField.text = self.product.title;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    priceCell.textField.text = [numberFormatter stringFromNumber:self.product.price];
    amountCell.textField.text = [numberFormatter stringFromNumber:self.product.amount];
    
    countryCell.textField.text = self.product.country.name;
}

#pragma mark - Actions -

- (IBAction)actionSave:(id)sender
{
    ALTextEditTableViewCell *titleCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    ALTextEditTableViewCell *priceCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    ALTextEditTableViewCell *amountCell = (ALTextEditTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    ALSelectContryTableViewCell *countryCell = (ALSelectContryTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];

    NSString *title = titleCell.textField.text;
    self.product.title = title;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;

    self.product.price = [numberFormatter numberFromString:priceCell.textField.text];
    self.product.amount = [numberFormatter numberFromString:amountCell.textField.text];
    
    self.product.country  = countryCell.contry;
    
    [[ALCoreDataManager defaultManager] saveContext];
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SUCCESS", @"")
                                message:NSLocalizedString(@"Product Saved", @"")
                               delegate:self
                      cancelButtonTitle:NSLocalizedString(@"Good", @"")
                      otherButtonTitles:nil] show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
