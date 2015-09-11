//
//  ALPickerViewDataSource.h
//  Pods
//
//  Created by Aziz Latypov on 9/11/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ALDataSourceAbstract.h"

@interface ALPickerViewDataSource : ALDataSourceAbstract <UIPickerViewDataSource, UIPickerViewDelegate>

// dependencies
@property (strong, nonatomic) UIPickerView *pickerView;

@end