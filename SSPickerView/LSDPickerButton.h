//
//  LSDPickerButton.h
//  LSDoctor
//
//  Created by sillker on 16/7/22.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSDPickerButton : UIButton


+ (instancetype)buttonWithTittle:(NSString *)tittle titleColor:(UIColor *)color Font:(NSInteger)font;

// backgroupBtn(分开写是为了好看些😄)
+ (instancetype)backgroupButtonWithFrame:(CGRect)frame;
- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action;
@end
