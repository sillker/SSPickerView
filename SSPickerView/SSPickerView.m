//
//  SSPickerView.m
//  SSPickerViewDemo
//
//  Created by sillker on 2016/10/20.
//  Copyright © 2016年 sillker. All rights reserved.
//

#import "SSPickerView.h"
#import <Masonry/Masonry.h>
static const CGFloat padding = 50;

@interface SSPickerButton:UIButton

+ (instancetype)buttonWithTittle:(NSString *)tittle titleColor:(UIColor *)color Font:(NSInteger)font;

// backgroupBtn(分开写是为了好看些😄)
+ (instancetype)backgroupButtonWithFrame:(CGRect)frame;
- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action;
@end

@implementation SSPickerButton

+ (instancetype)buttonWithTittle:(NSString *)tittle titleColor:(UIColor *)color Font:(NSInteger)font
{
    SSPickerButton *button = [[SSPickerButton alloc] init];
    if (font) button.titleLabel.font = [UIFont systemFontOfSize:font];
    if (tittle) [button setTitle:tittle forState:UIControlStateNormal];
    if (color)  [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (instancetype)backgroupButtonWithFrame:(CGRect)frame
{
    SSPickerButton *button = [[SSPickerButton alloc] init];
    button.backgroundColor = [UIColor clearColor];
    [button setFrame:frame];
    
    return button;
}
- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end


@class SSPickerContainView;
@protocol SSPickerContainViewDelegate <NSObject>
@optional
- (void)didLeftButtonClick:(UIButton *)button;
- (void)didRightButtonClick:(UIButton *)button;
@end
@interface SSPickerContainView:UIView
/** 标题控件 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 左边按钮 */
@property (nonatomic,strong) UIButton *leftBtn;
/** 右边按钮 */
@property (nonatomic,strong) UIButton *rightBtn;
/** 分割线 */
@property (nonatomic,strong) UIView *separateline;
/** delegate */
@property (nonatomic,assign) id<SSPickerContainViewDelegate> delegate;
@end
@implementation SSPickerContainView

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
                                       titleColor:[UIColor colorWithRed:((0x8F95A3>>16)&0xFF)/256.0  green:((0x8F95A3>>8)&0xFF)/256.0   blue:((0x8F95A3)&0xFF)/256.0   alpha:1.0]
                                           Action:@selector(leftBtnClick:)];
        [self addSubview:self.leftBtn];
    }
    
    if (self.rightBtn == nil) {
        self.rightBtn = [self creatButtonWithTitle:@"确定"
                                        titleColor:[UIColor colorWithRed:((0x222222>>16)&0xFF)/256.0  green:((0x222222>>8)&0xFF)/256.0   blue:((0x222222)&0xFF)/256.0   alpha:1.0]
                                            Action:@selector(rightBtnClick:)];
        [self addSubview:self.rightBtn];
    }
    
    if (self.titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor colorWithRed:((0x222222>>16)&0xFF)/256.0  green:((0x222222>>8)&0xFF)/256.0   blue:((0x222222)&0xFF)/256.0   alpha:1.0];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    
    if (self.separateline == nil) {
        self.separateline = [[UIView alloc] init];
        self.separateline.backgroundColor = [UIColor colorWithRed:188.0/255. green:188.0/255. blue:188.0/255. alpha:0.5];
        [self addSubview:self.separateline];
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat BtnH = 50 * ([UIScreen mainScreen].bounds.size.height) / 667.;
    
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

- (SSPickerButton *)creatButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor Action:(nonnull SEL)action
{
    SSPickerButton *btn = [SSPickerButton buttonWithTittle:title
                                                  titleColor:titleColor
                                                        Font:16];
    [btn     addTarget:self
                action:action
      forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

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

@interface SSPickerView() <SSPickerContainViewDelegate>
/** 背景按钮 */
@property (nonatomic,strong) SSPickerButton *backGroupBtn;
/** containsView */
@property (nonatomic,strong) SSPickerContainView *containsView;
@end

@implementation SSPickerView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initViews];
        [self showPickView];
    }
    return self;
}
+ (instancetype)pickerView
{
    return [[self alloc] init];
}
+ (instancetype)pickerViewWithTitle:(NSString *)title contentes:(NSArray <NSString *>*)contentes
{
    SSPickerView *pick = [[SSPickerView alloc] init];
    pick.title = title;
    pick.contentes = [contentes copy];
    return pick;
}
- (void)initViews
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
    self.componentArray = [NSMutableArray array];
    
    if (self.backGroupBtn == nil) {
        self.backGroupBtn = [SSPickerButton backgroupButtonWithFrame:self.frame];
        [self.backGroupBtn addBackgroupBtnTarget:self Action:@selector(backGroupBtnClick:)];
        [self addSubview:self.backGroupBtn];
    }
    
    if (self.containsView == nil) {
        CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 3 * 65 * ([UIScreen mainScreen].bounds.size.height) / 667. + 50 * ([UIScreen mainScreen].bounds.size.height) / 667.);
        self.containsView = [[SSPickerContainView alloc] initWithFrame:rect];
        self.containsView.delegate = self;
        [self addSubview:self.containsView];
    }
    
    if (self.pickView == nil) {
        self.pickView = [[UIPickerView alloc] init];
        self.pickView.dataSource = self;
        self.pickView.delegate = self;
        self.pickView.showsSelectionIndicator = YES;
        [self.containsView addSubview:self.pickView];
    }
    
    if (self.iconView == nil) {
        self.iconView = [[UIImageView alloc] init];
        [self.containsView addSubview:self.iconView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat BtnH = 50 * ([UIScreen mainScreen].bounds.size.height) / 667.;
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containsView).offset(BtnH);
        make.bottom.mas_equalTo(self.containsView);
        make.trailing.mas_equalTo(self.containsView).offset(-10);
        make.leading.mas_equalTo(self.containsView).offset(10);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.pickView);
        make.leading.mas_equalTo(self.pickView).offset(30);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.componentArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *array = [self.componentArray objectAtIndex:component];
    return array.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *array = (NSArray *)[self.componentArray objectAtIndex:component];
    return [array objectAtIndex:row % array.count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    NSInteger count = [self.componentArray count];
    NSInteger temp = 10;
    if (count == 2) {
        if ([UIScreen mainScreen].bounds.size.width > 320) temp = temp + 17;
        return ([UIScreen mainScreen].bounds.size.width - 2 * padding) / count - temp;
    }else{
        return ([UIScreen mainScreen].bounds.size.width - 2 * padding) / count - temp;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 65 * ([UIScreen mainScreen].bounds.size.height) / 667.;
}

#pragma mark - action
- (void)backGroupBtnClick:(UIButton *)button
{
    [self hidePickView];
}

// MARK: LSDPickerContainViewDelegate
// 取消
- (void)didLeftButtonClick:(UIButton *)button
{
    [self hidePickView];
}
// 确认
- (void)didRightButtonClick:(UIButton *)button
{
    [self handlePickerContentResult];
    [self hidePickView];
}

- (void)showPickView
{
    self.backgroundColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:0.];
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;
        self.backgroundColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:0.6];
        self.containsView.transform = CGAffineTransformMakeTranslation(0, -(3 * 65 * ([UIScreen mainScreen].bounds.size.height) / 667. + 50 * ([UIScreen mainScreen].bounds.size.height) / 667.));
    }];
}
- (void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:0.];
        self.containsView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        [self.containsView removeFromSuperview];
        self.containsView = nil;
        [self removeFromSuperview];
    }];
}
- (void)pickerViewResult:(PickerViewResults)pickerViewBlock{
    _pickerViewBlock = pickerViewBlock;
}
/**
 *  处理pickerview选择之后的结果
 *  结果为string 或者 string-string-string
 */
- (void)handlePickerContentResult
{
    NSString *fullString = [NSString string];
    NSInteger count = [self.componentArray count];
    for (NSInteger i = 0; i < count; i++) {
        NSArray *selArray = [self.componentArray objectAtIndex:i];
        if (selArray.count > 0) {
            NSInteger index = [self.pickView selectedRowInComponent:i] % selArray.count;
            NSString *selString = [selArray objectAtIndex:index];
            if (i == 0) {
                fullString = [fullString stringByAppendingString:selString];
            }else{
                NSString *temp = [NSString stringWithFormat:@"-%@",selString];
                fullString = [fullString stringByAppendingString:temp];
            }
        }else{
            fullString = @"";
            NSLog(@"===>>>pickerview所选竟然为nil");
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(basePickerView:Content:)]) {
        [self.delegate basePickerView:self Content:fullString];
    }
    if (_pickerViewBlock) {
        self.pickerViewBlock(fullString,self);
    }
}

#pragma mark - get
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = self.containsView.titleLabel;
    }
    return _titleLabel;
}
- (UIButton *)leftButton
{
    if (!_leftButton) {
        _leftButton = self.containsView.leftBtn;
    }
    return _leftButton;
}
- (UIButton *)rightButton
{
    if (!_rightButton) {
        _rightButton = self.containsView.rightBtn;
    }
    return _rightButton;
}
#pragma mark - set
- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}
- (void)setContentes:(NSArray <NSArray <NSString *>*>*)contentes
{
    _contentes = contentes;
    
    if (contentes == nil || contentes.count == 0) {
        return;
    }
    
    NSArray *tempArray = contentes.firstObject;
    [self.componentArray removeAllObjects];
    if ([tempArray isKindOfClass:[NSArray class]]) {
        
        [contentes enumerateObjectsUsingBlock:^(NSArray<NSString *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.componentArray addObject:obj];
        }];
    }else if([tempArray isKindOfClass:[NSMutableArray class]]){
        
        for (NSArray *array in contentes) {
            [self.componentArray addObject:[array copy]];
        }
        
    }else{
        NSAssert(NO, @"contentes里面必须还是数组，数组里必须是string");
    }
}


@end
