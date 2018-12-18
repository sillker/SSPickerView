//
//  ViewController.m
//  SSPickerViewDemo
//
//  Created by sillker on 2016/10/12.
//  Copyright © 2016年 sillker. All rights reserved.
//

#import "ViewController.h"
#import "LSDBirthdayPickerView.h"
#import "LSDTimePickerView.h"


@interface ViewController ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, assign) BOOL select;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.select = YES;
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.showLabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickSelectBtn:(UIButton *)sender
{
    __weak typeof(self) weaksekf = self;
    if (self.select)
    {
        LSDBirthdayPickerView *bir = [LSDBirthdayPickerView pickerView];
        [bir pickerViewResult:^(NSString *text, NSString *selectIndex, SSPickerView *pickerView) {
            weaksekf.showLabel.text = text;
        }];
    }
    else
    {
//        LSDTimePickerView *time = [LSDTimePickerView pickerView];
//        time.pickerViewBlock = ^(NSString *text, NSString *selectIndex, SSPickerView *pickerView) {
//            weaksekf.showLabel.text = text;
//        };
        [SSPickerView pickerViewWithTitle:@"hello" contentes:@[@[@"1",@"2"],@[@"3",@"4"]] Finish:^(NSString *text, NSString *selectIndex, SSPickerView *pickerView) {
            weaksekf.showLabel.text = text;
        }];
    }
    self.select = !self.select;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
        _selectBtn.backgroundColor = [UIColor orangeColor];
        [_selectBtn setTitle:@"Try" forState:UIControlStateNormal];
        [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UILabel *)showLabel
{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
        _showLabel.backgroundColor = [UIColor yellowColor];
        _showLabel.textColor = [UIColor blackColor];
    }
    return _showLabel;
}
@end
