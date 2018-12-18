# SSPickerView
简单对uipickerview封装，方便使用，也方便拓展


[SSPickerView pickerViewWithTitle:@"hello" contentes:@[@[@"1",@"2"],@[@"3",@"4"]] Finish:^(NSString *text, NSString *selectIndex, SSPickerView *pickerView) {
            self.showLabel.text = text;
}];
