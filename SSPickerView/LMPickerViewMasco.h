//
//  LMPickerViewMasco.h
//  QQMusic
//
//  Created by sillker on 2016/10/12.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#ifndef LMPickerViewMasco_h
#define LMPickerViewMasco_h



static const CGFloat padding = 50;
#define rowH 65 * LMScaleH
#define BtnH 50 * LMScaleH
// 缩放比
#define LMScaleW ([UIScreen mainScreen].bounds.size.width) / 375.
#define LMScaleH ([UIScreen mainScreen].bounds.size.height) / 667.

#define LMScreenW [UIScreen mainScreen].bounds.size.width
#define LMScreenH [UIScreen mainScreen].bounds.size.height

#define LMRGBA(a, b, c, p) [UIColor colorWithRed:a/255. green:b/255. blue:c/255. alpha:p]

#define LMHexRGBA(c,a)  [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]

#define LMHexRGB(c) LMHexRGBA(c,1.0)

#endif /* LMPickerViewMasco_h */
