//
//  ALPickerViewDataSource.m
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import "ALPickerViewDataSource.h"

@implementation ALPickerViewDataSource

-(void)setPickerView:(UIPickerView *)pickerView
{
    _pickerView = pickerView;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self numberOfSections];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self numberOfObjectsInSection:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:component]];
}

@end
