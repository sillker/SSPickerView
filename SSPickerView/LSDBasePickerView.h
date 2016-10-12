//
//  LSDBasePickerView.h
//  LSDoctor
//
//  Created by sillker on 16/7/21.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSDBasePickerView;
typedef void(^PickerViewResults) (NSString *text,LSDBasePickerView *pickerView);

@protocol LSDBasePickerViewDelegate <NSObject>
@optional
/**
 *  返回选择的结果
 *
 *  @param pickerView self
 *  @param content    string 或者 string-string...
 */
- (void)basePickerView:(LSDBasePickerView *)pickerView Content:(NSString *)content;

@end

@interface LSDBasePickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>
/** 数据源 */
@property (nonatomic,strong) NSMutableArray *componentArray;
#pragma mark - 控件
/** UIPickerView */
@property (nonatomic,strong) UIPickerView *pickView;
/** 可显示的图片 */
@property (nonatomic,strong) UIImageView *iconView;
/** 标题控件 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 左边按钮 */
@property (nonatomic,strong) UIButton *leftButton;
/** 右边按钮 */
@property (nonatomic,strong) UIButton *rightButton;

#pragma mark - 属性
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 内容-数组 */
@property (nonatomic,strong) NSArray <NSArray <NSString *>*>*contentes;
/** block */
@property (nonatomic, copy) PickerViewResults pickerViewBlock;
@property (nonatomic,assign) id<LSDBasePickerViewDelegate> delegate;


#pragma mark - 方法
+ (instancetype)pickerView;
+ (instancetype)pickerViewWithTitle:(NSString *)title contentes:(NSArray <NSArray <NSString *>*>*)contentes;

- (void)showPickView;
- (void)hidePickView;
/**
 *  pickerView回调
 */
- (void)pickerViewResult:(PickerViewResults)pickerViewBlock;
@end
