//
//  LSDPickerContainView.h
//  LSDoctor
//
//  Created by sillker on 16/7/21.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSDPickerContainView;
@protocol LSDPickerContainViewDelegate <NSObject>
@optional
- (void)didLeftButtonClick:(UIButton *)button;
- (void)didRightButtonClick:(UIButton *)button;

@end

@interface LSDPickerContainView : UIView
/** 标题控件 */
@property (nonatomic,strong) UILabel *titleLabel;
/** 左边按钮 */
@property (nonatomic,strong) UIButton *leftBtn;
/** 右边按钮 */
@property (nonatomic,strong) UIButton *rightBtn;
/** 分割线 */
@property (nonatomic,strong) UIView *separateline;
/** delegate */
@property (nonatomic,assign) id<LSDPickerContainViewDelegate> delegate;

@end
