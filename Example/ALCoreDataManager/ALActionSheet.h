//
//  ALActionSheet.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 01/10/15.
//  Copyright © 2015 aziz u. latypov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALActionSheet;

typedef void(^ALActionSheetClickedBlock)(ALActionSheet *actionSheet, NSUInteger buttonIndex);

@interface ALActionSheet : UIActionSheet
@property (nonatomic, copy) ALActionSheetClickedBlock clickedBlock;

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
