//
//  SSPickerView.m
//  SSPickerViewDemo
//
//  Created by sillker on 2016/10/20.
//  Copyright © 2016年 sillker. All rights reserved.
//

#import "SSPickerView.h"

static const CGFloat padding = 50.0f;

#define lm_screen_width  [UIScreen mainScreen].bounds.size.width
#define lm_screen_height [UIScreen mainScreen].bounds.size.height


UIKIT_STATIC_INLINE UIColor * lm_ColorHex(NSInteger hex, CGFloat alpha) {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:alpha];
}

UIKIT_STATIC_INLINE UIColor * lm_ColorRGBA(CGFloat a, CGFloat b, CGFloat c, CGFloat alpha) {
    return [UIColor colorWithRed:a/255. green:b/255. blue:c/255. alpha:alpha];
}


@interface SSPickerButton:UIButton

+ (instancetype)buttonWithTittle:(NSString *)tittle
                      titleColor:(UIColor *)color
                            Font:(NSInteger)font;

+ (instancetype)backgroupButtonWithFrame:(CGRect)frame;

- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action;

@end

@implementation SSPickerButton

+ (instancetype)buttonWithTittle:(NSString *)tittle titleColor:(UIColor *)color Font:(NSInteger)font {
    
    SSPickerButton *button = [[SSPickerButton alloc] init];
    if (font) button.titleLabel.font = [UIFont systemFontOfSize:font];
    if (tittle) [button setTitle:tittle forState:UIControlStateNormal];
    if (color)  [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

+ (instancetype)backgroupButtonWithFrame:(CGRect)frame {
    SSPickerButton *button = [[SSPickerButton alloc] init];
    [button setFrame:frame];
    
    return button;
}

- (void)addBackgroupBtnTarget:(id)target Action:(SEL)action {
    [self addTarget:target
             action:action
   forControlEvents:UIControlEventTouchUpInside];
}

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

@property (copy, nonatomic) void (^ClickLeftBtnBlock) (void);
@property (copy, nonatomic) void (^ClickRightBtnBlock)(void);

@end

@implementation SSPickerContainView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self lm_initViews];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)lm_initViews {
    
    _leftBtn = [self creatButtonWithTitle:@"取消"
                               titleColor:lm_ColorHex(0x8F95A3, 1)
                                   Action:@selector(leftBtnClick:)];
    [self addSubview:_leftBtn];
    
    
    _rightBtn = [self creatButtonWithTitle:@"确定"
                                titleColor:lm_ColorHex(0x222222, 1)
                                    Action:@selector(rightBtnClick:)];
    [self addSubview:_rightBtn];

    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = lm_ColorHex(0x222222, 1);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    
    _separateline = [[UIView alloc] init];
    _separateline.backgroundColor = lm_ColorRGBA(188, 188, 188, 0.5);
    [self addSubview:_separateline];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat BtnH = 50 * lm_screen_height / 667.;
    
    _leftBtn.frame = CGRectMake(0, 0, BtnH, BtnH);
    
    _rightBtn.frame = CGRectMake(lm_screen_width - BtnH, 0, BtnH, BtnH);
    
    _titleLabel.frame = CGRectMake(0, 0, 200, BtnH);
    CGPoint center = CGPointMake(lm_screen_width *0.5, BtnH*0.5);
    _titleLabel.center = center;
    
    _separateline.frame = CGRectMake(10, BtnH-1, lm_screen_width-20, 0.5);
}

- (SSPickerButton *)creatButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor Action:(nonnull SEL)action {
    
    SSPickerButton *btn = [SSPickerButton buttonWithTittle:title
                                                  titleColor:titleColor
                                                        Font:16];
    [btn     addTarget:self
                action:action
      forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)leftBtnClick:(UIButton *)button {
    self.ClickLeftBtnBlock();
}

- (void)rightBtnClick:(UIButton *)button {
    self.ClickRightBtnBlock();
}

@end






@interface SSPickerView()
/** 背景按钮 */
@property (nonatomic,strong) SSPickerButton *backGroupBtn;
/** containsView */
@property (nonatomic,strong) SSPickerContainView *containsView;

@property (copy, nonatomic) PickerViewResults finishBlock;
@end

@implementation SSPickerView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self lm_initViews];
        [self showPickView];
    }
    return self;
}

+ (instancetype)pickerView {
    return [[self alloc] init];
}

+ (instancetype)pickerViewWithTitle:(NSString *)title contentes:(NSArray <NSString *>*)contentes {
    SSPickerView *pickView = [[SSPickerView alloc] init];
    pickView.title         = title;
    pickView.contentes     = [contentes copy];
    return pickView;
}

+ (instancetype)pickerViewWithTitle:(NSString *)title
                          contentes:(NSArray <NSArray <NSString *>*>*)contentes
                             Finish:(PickerViewResults)finish {
    SSPickerView *pickView = [self pickerViewWithTitle:title contentes:contentes];
    pickView.finishBlock = finish;
    return pickView;
}

#pragma mark - event
- (void)backGroupBtnClick:(UIButton *)button {
    [self hidePickView];
}

// 取消
- (void)leftButtonEvent {
    [self hidePickView];
}
// 确认
- (void)rightButtonEvent {
    [self handlePickerContentResult];
    [self hidePickView];
}

/**
 *  处理pickerview选择之后的结果
 *  结果为string 或者 string-string-string
 */
- (void)handlePickerContentResult {
    
    NSString *fullString  = [NSString string];
    NSString *indexString = [NSString string];
    NSInteger count = [self.componentArray count];
    for (NSInteger i = 0; i < count; i++) {
        NSArray *selArray = [self.componentArray objectAtIndex:i];
        if (selArray.count > 0) {
            NSInteger index = [self.pickView selectedRowInComponent:i] % selArray.count;
            NSString *selString = [selArray objectAtIndex:index];
            if (i == 0) {
                fullString = [fullString stringByAppendingString:selString];
                indexString = [indexString stringByAppendingString:[NSString stringWithFormat:@"%zd",index]];
                
            }else{
                NSString *temp = [NSString stringWithFormat:@"-%@",selString];
                fullString = [fullString stringByAppendingString:temp];
                indexString = [indexString stringByAppendingString:[NSString stringWithFormat:@"-%zd",index]];
            }
        }else{
            fullString  = @"";
            indexString = @"";
            NSLog(@"===>>>pickerview所选竟然为nil");
        }
    }
    
    if (_pickerViewBlock) {
        self.pickerViewBlock(fullString,indexString,self);
    }
    if (self.finishBlock) {
        self.finishBlock(fullString,indexString,self);
    }
}

- (void)showPickView {
    self.backgroundColor = lm_ColorRGBA(51, 51, 51, 0);
    [UIView animateWithDuration:0.25 animations:^{
        self.hidden = NO;
        self.backgroundColor = lm_ColorRGBA(51, 51, 51, 0.6);
        self.containsView.transform = CGAffineTransformMakeTranslation(0, -(3 * 65 * lm_screen_height / 667. + 50 * lm_screen_height / 667.));
    }];
}

- (void)hidePickView {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = lm_ColorRGBA(51, 51, 51, 0);
        self.containsView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.hidden = YES;
        [self.containsView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)pickerViewResult:(PickerViewResults)pickerViewBlock{
    _pickerViewBlock = pickerViewBlock;
}



#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.componentArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *array = [self.componentArray objectAtIndex:component];
    return array.count;
}

#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *array = (NSArray *)[self.componentArray objectAtIndex:component];
    return [array objectAtIndex:row % array.count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    NSInteger count = [self.componentArray count];
    NSInteger temp = 10;
    if (count == 2) {
        if ([UIScreen mainScreen].bounds.size.width > 320) temp = temp + 17;
        return ([UIScreen mainScreen].bounds.size.width - 2 * padding) / count - temp;
    }else{
        return ([UIScreen mainScreen].bounds.size.width - 2 * padding) / count - temp;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 65 * ([UIScreen mainScreen].bounds.size.height) / 667.;
}



#pragma mark - set
- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}
- (void)setContentes:(NSArray <NSArray <NSString *>*>*)contentes {
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

#pragma mark - get
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = self.containsView.titleLabel;
    }
    return _titleLabel;
}
- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = self.containsView.leftBtn;
    }
    return _leftButton;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = self.containsView.rightBtn;
    }
    return _rightButton;
}

#pragma mark - initView
- (void)lm_initViews {
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIWindow alloc] init];
        window.backgroundColor = lm_ColorHex(0xffffff, 1.0);
        window.frame = rect;
    }
    self.frame = rect;
    [window addSubview:self];
    
    
    self.backgroundColor = lm_ColorRGBA(51, 51, 51, 1);
    self.componentArray = [NSMutableArray array];
    
    
    _backGroupBtn = [SSPickerButton backgroupButtonWithFrame:rect];
    [_backGroupBtn addBackgroupBtnTarget:self Action:@selector(backGroupBtnClick:)];
    [self addSubview:_backGroupBtn];
    
    CGRect containViewRect = CGRectMake(0, lm_screen_height, lm_screen_width, 3 * 65 * (lm_screen_height) / 667. + 50 * (lm_screen_height) / 667.);
    _containsView = [[SSPickerContainView alloc] initWithFrame:containViewRect];
    [self addSubview:_containsView];
    __weak typeof(self) weakSelf = self;
    _containsView.ClickLeftBtnBlock = ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf leftButtonEvent];
    };
    _containsView.ClickRightBtnBlock = ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf rightButtonEvent];
    };
    
    CGFloat BtnH = 50 * (lm_screen_height/667.);
    
    _pickView = [[UIPickerView alloc] init];
    _pickView.frame = CGRectMake(10, BtnH, lm_screen_width-20, _containsView.bounds.size.height-BtnH);
    _pickView.dataSource = self;
    _pickView.delegate   = self;
    _pickView.showsSelectionIndicator = YES;
    [_containsView addSubview:_pickView];
    
    
    _iconView = [[UIImageView alloc] init];
    [_containsView addSubview:_iconView];
    _iconView.frame  = CGRectMake(40, 0, 10, 10);
    CGPoint center   = _iconView.center;
    center.y = BtnH + CGRectGetHeight(_pickView.frame)*0.5;
    _iconView.center = center;
}

@end
