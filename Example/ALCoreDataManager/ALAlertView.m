//
//  ALAlertView.m
//  ALCoreDataManager
//
//  Created by Aziz Latypov on 01/10/15.
//  Copyright © 2015 aziz u. latypov. All rights reserved.
//

#import "ALAlertView.h"

@interface ALAlertView () <UIAlertViewDelegate>

@end

@implementation ALAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.clickedBlock)
        self.clickedBlock((ALAlertView*)alertView, buttonIndex);
}

@end
