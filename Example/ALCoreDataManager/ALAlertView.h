//
//  ALAlertView.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 01/10/15.
//  Copyright © 2015 aziz u. latypov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ALAlertView;

typedef void(^ALAlertViewClickedBlock)(ALAlertView *alertView, NSUInteger buttonIndex);

@interface ALAlertView : UIAlertView

@property (nonatomic, copy) ALAlertViewClickedBlock clickedBlock;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
