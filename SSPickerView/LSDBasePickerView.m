//
//  LSDBasePickerView.m
//  LSDoctor
//
//  Created by sillker on 16/7/21.
//  Copyright © 2016年 lifesense. All rights reserved.
//  成功与否

#import "LSDBasePickerView.h"
#import "LSDPickerContainView.h"
#import "LSDPickerButton.h"
#import "LMPickerViewMasco.h"
#import <Masonry/Masonry.h>

@interface LSDBasePickerView() <LSDPickerContainViewDelegate>
/** 背景按钮 */
@property (nonatomic,strong) LSDPickerButton *backGroupBtn;
/** containsView */
@property (nonatomic,strong) LSDPickerContainView *containsView;
@end

@implementation LSDBasePickerView

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
    LSDBasePickerView *pick = [[LSDBasePickerView alloc] init];
    pick.title = title;
    pick.contentes = [contentes copy];
    return pick;
}
- (void)initViews
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = CGRectMake(0, 0, LMScreenW, LMScreenH);
    self.backgroundColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
    self.componentArray = [NSMutableArray array];
    
    if (self.backGroupBtn == nil) {
        self.backGroupBtn = [LSDPickerButton backgroupButtonWithFrame:self.frame];
        [self.backGroupBtn addBackgroupBtnTarget:self Action:@selector(backGroupBtnClick:)];
        [self addSubview:self.backGroupBtn];
    }
    
    if (self.containsView == nil) {
        CGRect rect = CGRectMake(0, LMScreenH, LMScreenW, 3 * rowH + BtnH);
        self.containsView = [[LSDPickerContainView alloc] initWithFrame:rect];
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
        self.iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:(@"bg_point_picker")]];
        [self.containsView addSubview:self.iconView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
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
        if (LMScreenW > 320) temp = temp + 17;
        return (LMScreenW - 2 * padding) / count - temp;
    }else{
        return (LMScreenW - 2 * padding) / count - temp;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return rowH;
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
    self.backgroundColor = LMRGBA(51, 51, 51, 0.);
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;
        self.backgroundColor = LMRGBA(51, 51, 51, 0.6);
        self.containsView.transform = CGAffineTransformMakeTranslation(0, -(3 * rowH + BtnH));
    }];
}
- (void)hidePickView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = LMRGBA(51, 51, 51, 0.);
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
