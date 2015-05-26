//
//  JHCommonAddressViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-10.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHCommonAddressViewController.h"

#import "JHAddOrEditAddressViewController.h"
#import "JHCommonAddressTableViewCell.h"
#import "JHCommonAdress.h"

@interface JHCommonAddressViewController ()<UITableViewDataSource, UITableViewDelegate, JHCommonAddressTableViewCellDelegate>

@property(nonatomic, strong) JHCommonAdress *commonAdress;
@property(nonatomic, strong) NSMutableArray *commonAddresses;

@property(nonatomic, strong) UITableView *commonAddressTableView;

@property (nonatomic, strong) UILabel *message;

@property (nonatomic, strong) UIButton *cover;

@end

@implementation JHCommonAddressViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationItem setTitle:@"常用地址"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClickedToAddCommonAddress)];
    
    [self showOerderNone];
    
    if (self.commonAddressTableView == nil) {
        [self setupMyCommonAddressTableView];
    }
    [self requestCommonAddressList];
    
}

#pragma mark - --------------------其他方法入口--------------------
- (void)showDemonstrate
{
    // 1.添加阴影
    UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (kDeviceHeight == 480) {
        
        cover.frame = CGRectMake(0, 0, kDeviceWidth, 568);
        
    }else{
        
        cover.frame = self.view.window.bounds;
        
    }
    
    if (kDeviceHeight == 667) {
        
        [cover setBackgroundImage:[UIImage imageNamed:@"demo_address_six"] forState:UIControlStateNormal];
        [cover setBackgroundImage:[UIImage imageNamed:@"demo_address_six"] forState:UIControlStateHighlighted];
        
    }else{
        
        [cover setBackgroundImage:[UIImage imageNamed:@"demo_address"] forState:UIControlStateNormal];
        [cover setBackgroundImage:[UIImage imageNamed:@"demo_address"] forState:UIControlStateHighlighted];
        
    }
    
    
    
    [cover addTarget:self action:@selector(hidensDemonstrate) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:cover];
    self.cover = cover;
    
}



- (void)hidensDemonstrate
{
    
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        // 阴影慢慢消失
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画执行完毕后会自动调用这个block内部的代码
        // 动画执行完毕后,移除遮盖(从内存中移除)
        [self.cover removeFromSuperview];
        self.cover = nil;
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (self.commonAddresses.count > 0) {
        
        self.message.hidden = YES;
        
    }else{
        
        self.message.hidden = NO;
    }
    
    if (self.commonAddressTableView != nil) {
        [self requestCommonAddressList];
    }
    
}

- (NSMutableArray *)commonAddresses
{
    if (_commonAddresses == nil) {
        _commonAddresses = [NSMutableArray array];
    }
    return _commonAddresses;
}


- (void)requestCommonAddressList
{
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"]};
    
    [[XMDealTool sharedXMDealTool] getCommonAddressListWithParams:param Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            NSArray *datalist = deal[@"datalist"];
            if ([datalist isKindOfClass:[NSArray class]] && datalist.count) {
                //联系人列表不为空
                [self removeImage];
                
                NSMutableArray *commonAddresses = [NSMutableArray array];
                for (NSDictionary *address in datalist) {
                    
                    JHCommonAdress *commonAdress = [[JHCommonAdress alloc] init];
                    [commonAdress setValues:address];
                    
                    [commonAddresses addObject:commonAdress];
                    
                }
                self.commonAddresses = commonAddresses;
                
                [self.commonAddressTableView reloadData];
            }else{
                //联系人列表为空
                [self removeImage];
                [self showOerderNone];
                
//                if (self.cover == nil && [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
//                    [self showDemonstrate];
//                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
//                }
                
                if (self.cover == nil) {
                    [self showDemonstrate];
                }
                
                
            }
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}
#pragma mark - 没地址
- (void)showOerderNone
{
    self.commonAddressTableView.hidden = YES;
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, kDeviceWidth, kDeviceHeight-64-44-49)];
    //    [image setImage:[UIImage imageNamed:@"order_none"]];
    //    image.tag = 101;
    //    image.contentMode = UIViewContentModeScaleAspectFit;
    //    [self.view addSubview:image];
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, 41)];
    self.message = message;
    message.numberOfLines = 2;
    message.center = self.view.center;
    [message setText:@"您还没有常用地址!"];
    message.textColor = kTextFontColor666;
    message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:message];
    message.tag = 101;
}
- (void)removeImage
{
    self.commonAddressTableView.hidden = NO;
    //    UIImageView *image = (UIImageView *)[self.view viewWithTag:101];
    //    if (image) {
    //        [image removeFromSuperview];
    //    }
    UILabel *message = (UILabel *)[self.view viewWithTag:101];
    if (message) {
        [message removeFromSuperview];
        message = nil;
    }
}

/** 确认选择  */
- (void)buttonClickedToAddCommonAddress
{
    JHAddOrEditAddressViewController *addOrEditAddressViewController = [[JHAddOrEditAddressViewController alloc] init];
    [self.navigationController pushViewController:addOrEditAddressViewController animated:YES];
    
}

#pragma mark - ---------------------------------------
#pragma mark - 初始化常用地址Tableview
#pragma mark - ---------------------------------------
- (void)setupMyCommonAddressTableView
{
    CGRect frame = CGRectMake(0, 64, kDeviceWidth, kDeviceHeight);
    UITableView *commonAddressTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    [commonAddressTableView setBackgroundColor:XMGlobalBg];
    commonAddressTableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    commonAddressTableView.delegate = self;
    commonAddressTableView.dataSource = self;
    
    self.commonAddressTableView = commonAddressTableView;
    [self.view addSubview:commonAddressTableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commonAddresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHCommonAdress *commonAdress = self.commonAddresses[indexPath.row];
    JHCommonAddressTableViewCell *commonAddressTableViewCell = [JHCommonAddressTableViewCell commonAddressTableViewCellWithTableView:tableView];
    
    commonAddressTableViewCell.commonAdress = commonAdress;
    commonAddressTableViewCell.delegate = self;
    commonAddressTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return commonAddressTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDisplay == NO) { // 选择常用地址
        
        JHCommonAdress *commonAdress = self.commonAddresses[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(commonAddressViewController:didSaveCommonAddress:)]) {
            [self.delegate commonAddressViewController:self didSaveCommonAddress:commonAdress];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }else{  // 展示常用地址
        
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.commonAddressTableView setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        if (indexPath.row < [self.commonAddresses count]) {
            
            JHCommonAdress *commonAdress = self.commonAddresses[indexPath.row];
            
            [self requestDataForDeleteCommonAddressWithID:commonAdress.ID];
            
            [self.commonAddresses removeObjectAtIndex:indexPath.row];//移除数据源的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (void)requestDataForDeleteCommonAddressWithID:(NSString *)ID
{
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"],
                            @"address_id" : ID};
    
    [[XMDealTool sharedXMDealTool] deleteCommonAddressWithParams:param Success:^(NSDictionary *deal){
        
        if ([deal[@"status"] isEqual: @1]) {
            
            [MBProgressHUD showSuccess:deal[@"message"]];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    
}


#pragma mark - -------------------------代理方法-------------------------
- (void)commonAddressCell:(JHCommonAddressTableViewCell *)commonAddressCell didSelectEditButton:(UIButton *)button
{
    NSIndexPath *indexPath = [self.commonAddressTableView indexPathForCell:commonAddressCell];
    JHAddOrEditAddressViewController *addOrEditAddressViewController = [[JHAddOrEditAddressViewController alloc] init];
    JHCommonAdress *commonAdress = self.commonAddresses[indexPath.row];
    addOrEditAddressViewController.commonAdress = commonAdress;
    
    [self.navigationController pushViewController:addOrEditAddressViewController animated:YES];
}

/** 绘制背景图片 */
+(void)drawViewBackgroundColor:(NSString *)backgroundColor view:(UIView *)view
{
    
    UIImage *image = [UIImage imageNamed:backgroundColor];
    view.layer.contents = (id)image.CGImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
