//
//  LSDTimePickerView.m
//  LSDoctor
//
//  Created by sillker on 16/7/22.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "LSDTimePickerView.h"

@interface LSDTimePickerView()
@property (nonatomic,strong) NSArray *hourArray;
@property (nonatomic,strong) NSArray *minuteArray;

@end

@implementation LSDTimePickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatTime];
    }
    return self;
}
+ (instancetype)pickerView
{
    return [[self alloc] init];
}
- (void)creatTime
{
    //1.hour
    NSMutableArray <NSString *>* hourArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<=23; i++)
    {
        [hourArray addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    self.hourArray = [hourArray copy];
    
    //2.minute
    NSMutableArray <NSString *>*miniuteArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<=59; i++)
    {
        [miniuteArray addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    self.minuteArray = [miniuteArray copy];
    
    // 3.设置内容和标题
    self.title = @"随访时间";
    self.contentes = @[[hourArray copy],[miniuteArray copy]];
    
    // 4.设置pickview显示当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString * currentHourString = [NSString stringWithFormat:@"%@",
                                    [formatter stringFromDate:date]];
    [formatter setDateFormat:@"mm"];
    
    NSString * currentMinuteString = [NSString stringWithFormat:@"%@",
                                      [formatter stringFromDate:date]];
    
    
    [self.pickView selectRow:[hourArray indexOfObject:currentHourString] inComponent:0 animated:YES];
    [self.pickView selectRow:[miniuteArray indexOfObject:currentMinuteString] inComponent:1 animated:YES];
}

- (void)setCurrentTime:(NSString *)timeStirng
{
    if (timeStirng == nil) {
        return;
    }
    
    NSArray <NSString *>*array = [timeStirng componentsSeparatedByString:@":"];
    if (array == nil) {
        array = [timeStirng componentsSeparatedByString:@"-"];
    }
    
    if (array.count == 2){
        NSString *hour = array[0];
        NSString *minute = array[1];
        
        NSInteger hourIndex = [self.hourArray indexOfObject:hour];
        NSInteger minuteIndex = [self.minuteArray indexOfObject:minute];
        
        if (hourIndex == -1 || minuteIndex == -1 || hourIndex >= self.hourArray.count || minuteIndex >= self.minuteArray.count) {
            return;
        }
        
        [self.pickView selectRow:hourIndex inComponent:0 animated:YES];
        [self.pickView selectRow:minuteIndex inComponent:1 animated:YES];
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 60;
}
@end
