//
//  LSDPickerButton.m
//  LSDoctor
//
//  Created by sillker on 16/7/22.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "LSDPickerButton.h"

@implementation LSDPickerButton

+ (instancetype)buttonWithTittle:(NSString *)tittle titleColor:(UIColor *)color Font:(NSInteger)font
{
    LSDPickerButton *button = [[LSDPickerButton alloc] init];
    if (font) button.titleLabel.font = [UIFont systemFontOfSize:font];
    if (tittle) [button setTitle:tittle forState:UIControlStateNormal];
    if (color)  [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}


#pragma mark - backGroup
+ (instancetype)backgroupButtonWithFrame:(CGRect)frame
{
    LSDPickerButton *button = [[LSDPickerButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    [button setFrame:frame];
    
    return button;
}
- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action
{
     [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
