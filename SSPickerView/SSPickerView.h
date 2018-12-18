//
//  SSPickerView.h
//  SSPickerViewDemo
//
//  Created by sillker on 2016/10/20.
//  Copyright © 2016年 sillker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSPickerView;

/**
 确认结果block

 @param text 结果为string 或者 string-string-string ...
 @param selectIndex 结果为index 或者 index-index-index ...
 @param pickerView SSPickerView
 */
typedef void(^PickerViewResults) (NSString *text,
                                  NSString *selectIndex,
                                  SSPickerView *pickerView);



@interface SSPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
/** 数据源(暴露出来方便拓展修改) */
@property (nonatomic,strong) NSMutableArray *componentArray;

#pragma mark - 控件
/** UIPickerView */
@property (nonatomic,strong) UIPickerView *pickView;
/** 可显示的图片 */
@property (nonatomic,strong) UIImageView  *iconView;
/** 标题控件 */
@property (nonatomic,strong) UILabel      *titleLabel;
/** 左边按钮 */
@property (nonatomic,strong) UIButton     *leftButton;
/** 右边按钮 */
@property (nonatomic,strong) UIButton     *rightButton;

#pragma mark - 属性
/** 标题 */
@property (nonatomic,copy) NSString *title;
/** 内容-数组 */
@property (nonatomic,copy) NSArray <NSArray <NSString *>*>*contentes;
/** block */
@property (nonatomic,copy) PickerViewResults pickerViewBlock;




#pragma mark - 方法
+ (instancetype)pickerView;
+ (instancetype)pickerViewWithTitle:(NSString *)title
                          contentes:(NSArray <NSArray <NSString *>*>*)contentes;

+ (instancetype)pickerViewWithTitle:(NSString *)title
                          contentes:(NSArray <NSArray <NSString *>*>*)contentes
                             Finish:(PickerViewResults)finish;

- (void)showPickView;
- (void)hidePickView;
/**
 *  pickerView回调
 */
- (void)pickerViewResult:(PickerViewResults)pickerViewBlock;

@end
