//
//  ALSelectContryTableViewCell.h
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 9/11/15.
//  Copyright (c) 2015 aziz u. latypov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Country;
@class ALSelectContryTableViewCell;

@protocol ALSelectContryTableViewCellDelegate <NSObject>
@optional
- (void)selectContryTableViewCell:(ALSelectContryTableViewCell*)ALSelectContryTableViewCell
                 didSelectCountry:(Country*)contry;
@end

@interface ALSelectContryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id<ALSelectContryTableViewCellDelegate> delegate;

@property (weak, nonatomic) Country *contry;

@end
