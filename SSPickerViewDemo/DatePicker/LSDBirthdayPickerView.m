//
//  LSDBirthdayPickerView.m
//  LSDoctor
//
//  Created by sillker on 16/7/22.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "LSDBirthdayPickerView.h"

@interface LSDBirthdayPickerView()
@property (nonatomic,strong) NSArray <NSString *>*yearArray;
@property (nonatomic,strong) NSArray <NSString *>*monthArray;
@property (nonatomic,strong) NSArray <NSString *>*dayArray;
@end

@implementation LSDBirthdayPickerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.yearArray  = [NSArray array];
        self.monthArray = [NSArray array];
        self.dayArray   = [NSArray array];
        [self creatData];
    }
    return self;
}
+ (instancetype)pickerView
{
    return [[self alloc] init];
}

- (void)creatData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    
    // 1.year
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    NSInteger year = [formatter stringFromDate:date].integerValue;
    NSMutableArray <NSString *>*yearArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1900; i <= year ; i++){
        [yearArray addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    
    // 2.month
    [formatter setDateFormat:@"MM"];
    NSString *currentMonth = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSInteger month = [formatter stringFromDate:date].integerValue;
    NSMutableArray <NSString *>*monthArray = [self creatMonthsWithYear:year];
    
    
    // 3.day
    [formatter setDateFormat:@"dd"];
    NSString *currentDay = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    NSMutableArray <NSString *>*dayArray = [self creatDaysWithMonth:month Year:year];
    
    // 4.设置内容和标题
    self.title = @"出生日期";
    self.contentes = @[[yearArray copy],[monthArray copy],[dayArray copy]];
    
    // 5.设置pickview显示当前时间
    [self.pickView selectRow:[yearArray  indexOfObject:currentYear]  inComponent:0 animated:YES];
    [self.pickView selectRow:[monthArray indexOfObject:currentMonth] inComponent:1 animated:YES];
    [self.pickView selectRow:[dayArray   indexOfObject:currentDay]   inComponent:2 animated:YES];
    
    self.yearArray  = [yearArray copy];
}
- (NSMutableArray <NSString *>*)creatMonthsWithYear:(NSInteger)year
{
    NSMutableArray *array = [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"MM"];
    NSString *currentMonth = [formatter stringFromDate:[NSDate date]];
    
    NSInteger count = 12;
    if (year == currentYear.integerValue) count = currentMonth.integerValue;
    
    for (NSInteger i = 1; i < (count + 1); i ++) {
        [array addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    
    return array;
}
- (NSMutableArray <NSString *>*)creatDaysWithMonth:(NSInteger)month Year:(NSInteger)year
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger day = 30;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        day = 31;
    }else if(month == 2){
        if(((0 == year%4)&&(0 != year%100)) || (0 == year %400)){ // 闰年
            day = 29;
        }else{
            day = 28;
        }
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *currentYear = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"MM"];
    NSString *currentMonth = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDay = [formatter stringFromDate:[NSDate date]];
    
    if (currentYear.integerValue == year && month >= currentMonth.integerValue) {
        day = currentDay.integerValue;
    }
    
    for (NSInteger i = 1; i < (day + 1); i++) {
        [array addObject:[NSString stringWithFormat:@"%02ld",(long)i]];
    }
    return array;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.contentes.count == 3) {
        NSArray <NSString *>*yearArray  = [self.componentArray objectAtIndex:0];
        NSArray <NSString *>*monthArray = [self.componentArray objectAtIndex:1];
        NSArray <NSString *>*dayArray   = [self.componentArray objectAtIndex:2];
        
        NSInteger yearIndex  = [pickerView selectedRowInComponent:0] % yearArray.count;
        NSInteger monthIndex = [pickerView selectedRowInComponent:1] % monthArray.count;
        NSInteger dayIndex   = [pickerView selectedRowInComponent:2] % dayArray.count;
        
        NSString *monthStr = [monthArray objectAtIndex:monthIndex];
        NSString *yearStr  = [yearArray objectAtIndex:yearIndex];
        NSString *dayStr   = [dayArray objectAtIndex:dayIndex];
        
        NSInteger month = [monthStr substringToIndex:2].integerValue;
        NSInteger year  = [yearStr substringToIndex:4].integerValue;
        
        NSMutableArray *months = [self creatMonthsWithYear:year];
        NSMutableArray *days   = [self creatDaysWithMonth:month Year:year];
        [self.componentArray replaceObjectAtIndex:1 withObject:[months copy]];
        [self.componentArray replaceObjectAtIndex:2 withObject:[days copy]];
        [pickerView reloadAllComponents];
        if (![days containsObject:dayStr]) {
            [pickerView selectRow:(days.count - 1) inComponent:2 animated:YES];
        }
    }
}


- (void)setDateWithString:(NSString *)dateStr
{
    if (dateStr == nil) {
        return;
    }
    
    NSArray <NSString *>*arr = [dateStr componentsSeparatedByString:@"-"];
    
    NSInteger month = arr[1].integerValue;
    NSInteger year  = arr[0].integerValue;
    
    NSMutableArray *months = [self creatMonthsWithYear:year];
    NSMutableArray *days   = [self creatDaysWithMonth:month Year:year];
    [self.componentArray replaceObjectAtIndex:1 withObject:[months copy]];
    [self.componentArray replaceObjectAtIndex:2 withObject:[days copy]];
    
    [self.pickView selectRow:[self.yearArray   indexOfObject:arr[0]]  inComponent:0 animated:YES];
    [self.pickView selectRow:[months  indexOfObject:arr[1]]  inComponent:1 animated:YES];
    
    [self.pickView reloadComponent:2];
    [self.pickView selectRow:[days    indexOfObject:arr[2]]  inComponent:2 animated:YES];
    if (![days containsObject:arr[2]]) {
        [self.pickView selectRow:(days.count - 1) inComponent:2 animated:YES];
    }

}
@end
