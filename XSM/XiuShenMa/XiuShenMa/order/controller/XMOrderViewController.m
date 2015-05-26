//
//  XMOrderViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMOrderViewController.h"
#import "XMMainViewController.h"
#import "XMBaseNavigationController.h"
//#import "XMOrderDetailViewController.h"
#import "XMLoginViewController.h"

#import "XMOrderDetail.h"
#import "NSObject+Value.h"

#import "XMOrderDetailCell.h"

@interface XMOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    int line;
}
@end

@implementation XMOrderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"当前订单";
    
    kRectEdge
    kNAVITAIONBACKBUTTON
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    kShowOrHiddenTabBar(NO);
    [self loadSubViews];
}

- (void)loadSubViews
{
    if (self.view.subviews.count) {
        for (UIView *subView in self.view.subviews) {
            [subView removeFromSuperview];
        }
    }
    //当用户处于未登录状态时,提示用户登录
    if (!flag) {
        self.view.backgroundColor = kBorderColor;
        QHLabel *remindLabel = [[QHLabel alloc] init];
        remindLabel.backgroundColor = [UIColor clearColor];
        remindLabel.frame = CGRectMake(0, self.view.height/2-20-64, self.view.width, kUIButtonHeight);
        remindLabel.font = [UIFont boldSystemFontOfSize:20];
        remindLabel.textAlignment = NSTextAlignmentCenter;
        remindLabel.text = @"您还没有登录修神马";
        [self.view addSubview:remindLabel];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(self.view.width/2-50, remindLabel.bottom+20, 100, kUIButtonHeight);
        [loginButton setTitle:@"立即登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        loginButton.backgroundColor = [UIColor grayColor];
        [loginButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
        
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        [self loadOrder];
        [self loadOrderDetailData];
    }
}

#pragma mark 初始化所有的订单信息
- (void)loadOrderDetailData
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"OrderDetail.json" ofType:nil]] options:NSJSONReadingMutableContainers error:NULL];
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *dic in array){
        XMOrderDetail *o = [[XMOrderDetail alloc] init];
        [o setValues:dic];
        [temp addObject:o];
    }
    _totalOrderDetail = temp;
}

- (void)loadOrder
{
    CGFloat height = [UIScreen mainScreen].applicationFrame.size.height;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, height - 44 -49) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = XMGlobalBg;
    
//    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark 表格方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _totalOrderDetail.count;
}

- (XMOrderDetailCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    XMOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[XMOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.orderDetail = _totalOrderDetail[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    XMOrderDetailViewController *detailVC = [[XMOrderDetailViewController alloc] init];
//    detailVC.orderDetail = _totalOrderDetail[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    kShowOrHiddenTabBar(YES)
}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//设置编辑非编辑状态
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (_tableView.editing) {
        [_tableView setEditing:NO animated:YES];
//        self.editButtonItem.title = @"编辑";
    }else {
        [_tableView setEditing:YES animated:YES];
//        self.editButtonItem.title = @"完成";
    }
}

// 设置单元格编辑的样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMOrderDetailCell *cell = (XMOrderDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isRating) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

//添加删除单元格
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:_totalOrderDetail];
        [array removeObjectAtIndex:indexPath.row];
        _totalOrderDetail = array;
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

////移动单元格
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath
//      toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    NSMutableArray *array = [NSMutableArray arrayWithArray:_totalOrderDetail];
//    NSDictionary *item = [array objectAtIndex:sourceIndexPath.row];
//    [array removeObjectAtIndex:sourceIndexPath.row];
//    [array insertObject:item atIndex:destinationIndexPath.row];
//}

#pragma mark 点击登录按钮
- (void)buttonClick
{
    [self.navigationController presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:[[XMLoginViewController alloc] init]] animated:YES completion:^{
    }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
