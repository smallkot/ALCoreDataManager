//
//  ALActionSheet.m
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 01/10/15.
//  Copyright © 2015 aziz u. latypov. All rights reserved.
//

#import "ALActionSheet.h"

@interface ALActionSheet () <UIActionSheetDelegate>

@end

@implementation ALActionSheet

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    va_list args;
    va_start(args, otherButtonTitles);
    id arg = nil;
    if (otherButtonTitles) {
        [self addButtonWithTitle:otherButtonTitles];
    }
    while ((arg = va_arg(args,id))) {
        [self addButtonWithTitle:arg];
    }
    va_end(args);
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.clickedBlock)
        self.clickedBlock((ALActionSheet*)actionSheet, buttonIndex);
}

@end
