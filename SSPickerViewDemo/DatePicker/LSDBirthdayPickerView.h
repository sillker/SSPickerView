//
//  LSDBirthdayPickerView.h
//  LSDoctor
//
//  Created by sillker on 16/7/22.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "LSDBasePickerView.h"

@interface LSDBirthdayPickerView : LSDBasePickerView
/**
 *  设置时间（格式为yyyy-MM-dd）
 */
- (void)setDateWithString:(NSString *)dateStr;
@end
