//
//  XMReportViewController.m
//  XiuShemMa
//
//  Created by Apple on 14/10/29.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMReportViewController.h"

@interface XMReportViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_titles;
    NSArray *_contents;
}
@end

@implementation XMReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNAVITAIONBACKBUTTON
    self.title = @"检测报告";
    
    _titles = @[@"故障描述",@"检测费",@"邮费",@"维修总价",@"维修周期",@"维修结果预测"];
    _contents = @[@"屏幕碎 图像显示正常",@{@"currentPrice":@0,@"price":@99},@"修神包邮！",@"原厂屏幕X1  ￥199.00\n维修费用     ￥100.00\n合    计        ￥299.00",@"10天",@"100%修好，跟新的一样"];
    
    [self loadSubViews];
    [self loadBottomItem];
}

- (void)loadSubViews
{
    self.view.backgroundColor = XMGlobalBg;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

- (void)loadBottomItem
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"同意维修" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    leftButton.frame = CGRectMake(0, kDeviceHeight-44, (kDeviceWidth-5)/2, kUIButtonHeight);
    rightButton.frame = CGRectMake(leftButton.right+5, leftButton.top, leftButton.width, kUIButtonHeight);
    
    leftButton.backgroundColor = XMButtonBg;
    rightButton.backgroundColor = XMButtonBg;
    
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark-
#pragma mark UITableViewDataSource && UITableViewDelegate
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
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 1) {
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.height = 100;
        cell.textLabel.text = [NSString stringWithFormat:@"￥%i   原价￥%i",[_contents[1][@"currentPrice"] intValue],[_contents[1][@"price"] intValue]];
    }else{
        if (indexPath.section == 3){cell.textLabel.numberOfLines = 0;}
        cell.textLabel.text = _contents[indexPath.section];
    }
    cell.textLabel.textColor = [UIColor blackColor];
//    cell.backgroundColor = XMColor(191, 191, 191);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 100;
    }else{
        return 60;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _titles[section];
}
#pragma mark - 底部按钮点击事件
- (void)buttonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"取消订单"]) {
        XMLog(@"取消订单");
    }else{
        XMLog(@"同意维修");
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
