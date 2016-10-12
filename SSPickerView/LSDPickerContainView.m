//
//  LSDPickerContainView.m
//  LSDoctor
//
//  Created by sillker on 16/7/21.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "LSDPickerContainView.h"
#import "LSDPickerButton.h"
#import "LMPickerViewMasco.h"

@interface LSDPickerContainView()

@end

@implementation LSDPickerContainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)initViews
{
    if (self.leftBtn == nil) {
        self.leftBtn = [self creatButtonWithTitle:@"取消"
                                         titleColor:LMHexRGB(0x8F95A3)
                                             Action:@selector(leftBtnClick:)];
        [self addSubview:self.leftBtn];
    }
    
    if (self.rightBtn == nil) {
        self.rightBtn = [self creatButtonWithTitle:@"确定"
                                          titleColor:LMHexRGB(0x222222)
                                              Action:@selector(rightBtnClick:)];
        [self addSubview:self.rightBtn];
    }
    
    if (self.titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = LMHexRGB(0x222222);
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    
    if (self.separateline == nil) {
        self.separateline = [[UIView alloc] init];
        self.separateline.backgroundColor = LMRGBA(188.0, 188.0, 188.0, 0.5);
        [self addSubview:self.separateline];
    }

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(BtnH);
        make.height.mas_equalTo(BtnH);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(BtnH);
        make.height.mas_equalTo(BtnH);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.rightBtn.mas_centerY);
    }];
    
    [self.separateline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftBtn.mas_bottom).offset(0);
        make.left.mas_equalTo(self).offset(10);
        make.trailing.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(0.5);
    }];

}

#pragma mark - privite
- (LSDPickerButton *)creatButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor Action:(nonnull SEL)action
{
    LSDPickerButton *btn = [LSDPickerButton buttonWithTittle:title
                                                    titleColor:titleColor
                                                          Font:16];
    [btn     addTarget:self
                action:action
      forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

#pragma mark - event
- (void)leftBtnClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLeftButtonClick:)]) {
        [self.delegate didLeftButtonClick:button];
    }
}
- (void)rightBtnClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRightButtonClick:)]) {
        [self.delegate didRightButtonClick:button];
    }
}

@end
