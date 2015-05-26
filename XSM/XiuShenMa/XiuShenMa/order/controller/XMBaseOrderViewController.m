//
//  XMBaseOrderViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseOrderViewController.h"

@interface XMBaseOrderViewController ()

@end

@implementation XMBaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeServices) name:kServicesChangeNote object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)loadContentView
{
    self.view.backgroundColor = XMGlobalBg;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = XMGlobalBg;
    
    _submitButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButtom.backgroundColor = XMButtonBg;
    _submitButtom.layer.cornerRadius = 5;
    [_submitButtom setTitle:@"填好了" forState:UIControlStateNormal];
    [_submitButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButtom addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButtom];
    
    _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:_tableView attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
    [UIView setView:_tableView attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
    [UIView setView:_tableView attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:64];
    [UIView setView:_tableView attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:-50];
    
    
    _submitButtom.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:_submitButtom attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:20];
    [UIView setView:_submitButtom attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:-20];
    [UIView setView:_submitButtom attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeBottom constant:-(50-kUIButtonHeight)/2-kUIButtonHeight];
    [UIView setView:_submitButtom attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:-(50-kUIButtonHeight)/2];
}

#pragma mark 表格方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderViewHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kHeaderViewHeight)];
    titleLabel.backgroundColor = XMColor(245, 245, 245);
    titleLabel.textColor = XMButtonBg;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.text = [NSString stringWithFormat:@"   %@",_titles[section] ];
    return titleLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (picker != nil) {
        [picker removeFromSuperview];
        picker = nil;
    }
    
    picker = [[XMPickerView alloc] init];
    picker.frame = CGRectMake(0, kDeviceHeight - 320 + 64, kDeviceWidth, 320);
    if (indexPath.section == 0) {
        picker.pickerViewStyle = kPickerViewStyleTime;
        picker.titleStr = @"修神上门时间";
        picker.delegate = self;
        [self.view addSubview:picker];
    }else if (indexPath.section == 1){
        //   联系人信息
        XMAddressBookViewController *addressBook = [[XMAddressBookViewController alloc] init];
        addressBook.isAllowEdit = NO;
        addressBook.title = @"联系人信息";
        [self.navigationController pushViewController:addressBook animated:YES];
    }else if (indexPath.section == 2){
        picker.pickerViewStyle = kPickerViewStyleModel;
        picker.titleStr = @"设备型号";
        picker.delegate = self;
        [self.view addSubview:picker];
    }else if (indexPath.section == 3){
        picker.pickerViewStyle = kPickerViewStyleDesc;
        picker.titleStr = @"故障描述";
        picker.delegate = self;
        [self.view addSubview:picker];
    }else if (indexPath.section == 4){
        [self.navigationController pushViewController:[[XMMoreServicesController alloc] init] animated:YES];
    }
}


#pragma mark - XMPickerViewDelegate
- (void)cancleOption
{
    [self removePickerView];
    [self hidePickerView];
}

- (void)enterOptionWithContent:(NSString *)string dictionary:(NSDictionary *)dic
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    cell.textLabel.text = string;
    NSInteger index = [[_tableView indexPathForSelectedRow] section];
    _content[index] = string;
//    [self removePickerView];
    [self hidePickerView];
    
//    XMLog(@"dic===========%@",dic);
    if (dic[@"item_id"]) {
        _item_id = dic[@"item_id"];
    }
    if (dic[@"attributeid"]) {
        _attributeid = dic[@"attributeid"];
    }
    if (dic[@"faultcategoryid"]) {
        _faultcategoryid = dic[@"faultcategoryid"];
    }
//    XMLog(@"111111111111%@\n222222222222222%@\n333333333333333%@",_item_id,_attributeid,_faultcategoryid);
}

#pragma mark - 移除pickerView
- (void)removePickerView
{
    picker.transform = CGAffineTransformMakeTranslation(0, -320);
    picker.alpha = 1;
    [UIView animateWithDuration:3 animations:^{
        picker.transform = CGAffineTransformIdentity;
        picker.alpha = 0;
    }];
    
    [picker removeFromSuperview];
    picker = nil;
}

#pragma mark - 修改单元格内容
- (void)changeServices
{
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[_tableView indexPathForSelectedRow]];
    cell.textLabel.text = [UserDefaults valueForKey:@"server"];
    NSInteger index = [[_tableView indexPathForSelectedRow] section];
    
    _content[index] = [UserDefaults valueForKey:@"server"];
}


- (void)showPickerView
{
    picker.transform = CGAffineTransformMakeTranslation(0, picker.height);
    picker.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        picker.transform = CGAffineTransformIdentity;//记录上一次变换的坐标系统
        
        picker.alpha = 1;
    }];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:0.3 animations:^{
        picker.transform = CGAffineTransformMakeTranslation(0, picker.height);
//        picker.alpha = 0;
    } completion:^(BOOL finished) {
        [picker removeFromSuperview];
        picker = nil;
    }];
}


- (void)submitButtonClick
{}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
