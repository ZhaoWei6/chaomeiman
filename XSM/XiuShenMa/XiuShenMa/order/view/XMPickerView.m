//
//  XMPickerView.m
//  XiuShemMa
//
//  Created by Apple on 14/10/21.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMPickerView.h"

@interface XMPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *topView;
    
    UIButton *cancleButton;//取消按钮
    UIButton *enterButton;//确定按钮
    UILabel *titleLabel;//标题
    
    UIPickerView *pickerView;//选择器
    //日期
    NSArray *days;
    NSMutableArray *hours;
    NSArray *hour_today;
}
@end

@implementation XMPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        days = @[@"今天",@"明天",@"后天"];
        hours = [NSMutableArray arrayWithCapacity:24];
        [self loadSubViews];
    }
    return self;
}

//加载子视图
- (void)loadSubViews
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kOrderHomeServiceTopViewHeight)];
    topView.backgroundColor = XMButtonBg;
    [self addSubview:topView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel sizeToFit];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [topView addSubview:titleLabel];
    
    cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleButton];
    cancleButton.frame = CGRectMake(0, 0, 80, topView.height);
    
    enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [enterButton setTitle:@"确定" forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:enterButton];
    enterButton.frame = CGRectMake(kDeviceWidth - 80, 0, 80, topView.height);
    
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:pickerView];
    pickerView.delegate = self;
    pickerView.dataSource = self;
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    
    titleLabel.text = _titleStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    titleLabel.frame = topView.frame;
    
    XMLog(@"%@",_titleStr);
}

- (void)setPickerViewStyle:(kPickerViewStyle)pickerViewStyle
{
    _pickerViewStyle = pickerViewStyle;
    
    [pickerView reloadAllComponents];
}

#pragma mark - UIPickerViewDatasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_pickerViewStyle == kPickerViewStyleTime) {
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (_pickerViewStyle == kPickerViewStyleTime) {
        return kDeviceWidth/3.0;
    }else{
        return kDeviceWidth/2.0;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView1 numberOfRowsInComponent:(NSInteger)component
{
    if (_pickerViewStyle == kPickerViewStyleTime) {
        if (component == 0) {
            return 3;
        }else if (component == 1){
            //返回第一列选择的行的索引
            NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
            //防止越界
            if (selectedRow<0||selectedRow>=3) {
                return 0;
            }
            
            if (selectedRow) {
                return 24;
            }else{
                NSDate*date = [NSDate date];
                NSCalendar*calendar = [NSCalendar currentCalendar];
                NSDateComponents*comps;
                comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
                                   fromDate:date];
                NSInteger hour = [comps hour];
                return 24-hour-1;
            }
        }else{
            return 2;
        }
    }else if (_pickerViewStyle == kPickerViewStyleModel){
        if (component == 0) {
            return _item.count;
        }else{
            //返回第一列选择的行的索引
            NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
            
            //防止越界
            if (selectedRow<0||selectedRow>=_item.count) {
                return 0;
            }
            
            return [_item[selectedRow][@"attr"] count];
        }
    }else{
        if (component == 0) {
            return _faultcategory.count;
        }
        //返回第一列选择的行的索引
        NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
        
        //防止越界
        if (selectedRow<0||selectedRow>=_faultcategory.count) {
            return 0;
        }
        
        return [_faultcategory[selectedRow][@"last"] count];
    }
}
#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView1
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
/////////////////////////////////////日期///////////////////////////////
    if (_pickerViewStyle == kPickerViewStyleTime) {
        [hours removeAllObjects];
        for (NSInteger i=0; i<=24; i++) {
            NSString *h = [NSString stringWithFormat:@"%i时",i];
            [hours addObject:h];
        }
        NSArray *m = @[@"00分",@"30分"];
        if (component == 0) {//第一列
            return days[row];
        }else if (component == 1){
            NSDate*date = [NSDate date];
            NSCalendar*calendar = [NSCalendar currentCalendar];
            NSDateComponents*comps;
            //当前的时分秒获得
            comps =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit)
                               fromDate:date];
            NSInteger hour = [comps hour];
            //返回第一列选择的行的索引
            NSInteger selectedRow = [pickerView selectedRowInComponent:0];
            
            if (selectedRow == 0) {
                [hours removeAllObjects];
                for (NSInteger i=hour+1; i<24; i++) {
                    NSString *h = [NSString stringWithFormat:@"%i时",i];
                    [hours addObject:h];
                }
                hour_today = [NSArray arrayWithArray:hours];
            }
            //防止越界
            if (row<0||row>=hours.count) {
                return @"";
            }
            
            return hours[row];
        }else{
            return m[row];
        }
    }
/////////////////////////////////////型号///////////////////////////////
    else if (_pickerViewStyle == kPickerViewStyleModel){
        if (!component) {
            return _item[row][@"item"];
        }else{
            //返回第一列选择的行的索引
            NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
            
            //防止越界
            if (row<0||row>=[_item[selectedRow][@"attr"] count]) {
                return @"";
            }
            return _item[selectedRow][@"attr"][row][@"attribute"];
        }
    }
/////////////////////////////////////故障///////////////////////////////
    if (!component) {
        return _faultcategory[row][@"typename"];
    }else{
        //返回第一列选择的行的索引
        NSInteger selectedRow = [pickerView1 selectedRowInComponent:0];
        
        //防止越界
        if (row<0||row>=[_faultcategory[selectedRow][@"last"] count]) {
            return @"";
        }
        
        return _faultcategory[selectedRow][@"last"][row][@"typename"];
    }
}

//选择行的事件
- (void)pickerView:(UIPickerView *)pickerView1
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    if (component == 0) {
      
        //刷新指定列中的行
      [pickerView1 reloadComponent:1];
        //选择指定的item
        [pickerView1 selectRow:0 inComponent:1 animated:YES];
        [pickerView1 reloadComponent:0];
        
    }
}

#pragma mark 顶部按钮
- (void)cancleButtonClick
{
    if ([_delegate respondsToSelector:@selector(cancleOption)]) {
        [_delegate cancleOption];
    }
}
- (void)enterButtonClick
{
    if ([_delegate respondsToSelector:@selector(enterOptionWithContent:dictionary:)]) {
/*******************************************时间*************************************************/
        if (_pickerViewStyle == kPickerViewStyleTime) {
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            NSString *minutes = [pickerView selectedRowInComponent:2] ? @"30分": @"00分";
            NSString *str;
            if (!row1) {
                str = [NSString stringWithFormat:@"%@%@%@",days[row1],hour_today[row2],minutes];
            }else{
                str = [NSString stringWithFormat:@"%@%@%@",days[row1],hours[row2],minutes];
            }
            [_delegate enterOptionWithContent:str dictionary:nil];
        }
/*******************************************类型*************************************************/
        //  需要返回  产品ID  属性ID
        else if (_pickerViewStyle == kPickerViewStyleModel){
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            NSString *str = [NSString stringWithFormat:@"%@(%@)",_item[row1][@"item"],_item[row1][@"attr"][row2][@"attribute"]];
            [_delegate enterOptionWithContent:str dictionary:@{@"item_id":_item[row1][@"attr"][row2][@"item_id"],@"attributeid":_item[row1][@"attr"][row2][@"attribute_id"]}];
        }
/*******************************************故障*************************************************/
        //  故障id
        else{
            NSInteger row1 = [pickerView selectedRowInComponent:0];
            NSInteger row2 = [pickerView selectedRowInComponent:1];
            NSString *str = [NSString stringWithFormat:@"%@(%@)",_faultcategory[row1][@"typename"],_faultcategory[row1][@"last"][row2][@"typename"]];
            [_delegate enterOptionWithContent:str dictionary:@{@"faultcategoryid":_faultcategory[row1][@"last"][row2][@"id"]}];
        }
    }
}



@end
