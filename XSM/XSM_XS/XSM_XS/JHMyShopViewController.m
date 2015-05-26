//
//  JHMyShopViewController.m
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHMyShopViewController.h"
#import "JHNotHaveShopView.h"
#import "JHNewSetShopViewController.h"
#import "JHShopDetail.h"
#import "JHShopDetail_WorkerCell.h"
#import "JHShopDetail_RatingCell.h"
#import "JHShopDetail_MyBabyCell.h"

#import "XMRatingListViewController.h"
#import "XMDevoteController.h"
#import "JHEditShopInfoViewController.h"
#import "JHNewSetShopViewController.h"

#import "XMAlbumViewController.h"

#import "XMLoginViewController.h"

@interface JHMyShopViewController ()<JHNotHaveShopViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIView *_headView;
    UIScrollView *_topScrollView;//顶部滑动视图
    UILabel *_currentIndex;//照片墙当前页标签
    UITableView *_tableView;
    NSArray *_arrayImage;
    UIAlertView  *alertView11;
    
    CGRect frame_first;
    UIImageView *fullImageView;
    
    UIButton *_collectButton;//收藏
}

@property(nonatomic, strong) JHShopDetail *shopDetail;

@end

@implementation JHMyShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isHaveShop = ([[UserDefaults objectForKey:@"approve"] integerValue]==5 || [[UserDefaults objectForKey:@"approve"] integerValue] == 4);
    
    [self setupContentView];
    
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingShopSuecess) name:@"SettingShopSuecess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageViewClickedToShowGoods:) name:@"SHOWGOODS" object:nil];
    
    [self setupNavigationItemInfo];
    
}

- (void)imageViewClickedToShowGoods:(NSNotification *)sender
{
    UIImageView *imageview = sender.object;
    
    [self touchImageViewWithImage:imageview.image];
}

- (void)settingShopSuecess
{
    self.isHaveShop = YES;
}

- (void)setupNavigationItemInfo
{
    [self.navigationItem setTitle:@"我的店铺"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (self.isHaveShop == YES) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(buttonClickToEditShopInfo)];
        
    }

}

- (void)setupContentView
{
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.isHaveShop == YES) {
        
        [self setupTableView];
        [self requestData];
        
    }else{

        JHNotHaveShopView *notHaveShopView = [JHNotHaveShopView notHaveShopView];
        notHaveShopView.frame = self.view.bounds;
        notHaveShopView.delegate = self;
        [self.view addSubview:notHaveShopView];
        
    }
    
}

#pragma mark - 请求数据
- (void)requestData
{
    
    NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                            @"password" : [UserDefaults objectForKey:@"password"],
                            @"type" : @"1"
                            };
    
    [[XMDealTool sharedXMDealTool] showShopDetailWithParams:param Success:^(NSDictionary *deal){
        
        JHShopDetail *shopDetail = [[JHShopDetail alloc] init];
        [shopDetail setValues:deal];
        self.shopDetail = shopDetail;
        
        
        [self loadHeadView];
        [_tableView reloadData];
    }];
}

#pragma mark - ------------------初始化TableView--------------------
- (void)setupTableView
{
    CGFloat tableView_y = 64;
    CGRect tableView_frame = CGRectMake(0, tableView_y, kDeviceWidth, kDeviceHeight - tableView_y*2);
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableView_frame style:UITableViewStyleGrouped];
    [tableView setBackgroundColor:XMGlobalBg];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    _tableView = tableView;
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {// 修神信息

        JHShopDetail_WorkerCell *cell = [JHShopDetail_WorkerCell shopDetail_WorkerCellWithTableView:tableView];
        cell.shopDetail = self.shopDetail;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1){// 评论
        
        JHShopDetail_RatingCell *cell = [JHShopDetail_RatingCell shopDetail_RatingCellWithTableView:tableView];
        cell.shopDetail = self.shopDetail;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else if (indexPath.section == 2){// 我的宝贝
        
        JHShopDetail_MyBabyCell *cell = [JHShopDetail_MyBabyCell shopDetail_MyBabyCellWithTableView:tableView];
        cell.shopDetail = self.shopDetail;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{// 服务类型
        
        NSArray *services = self.shopDetail.servicelist;
        NSMutableArray *servertype = [NSMutableArray array];
        for (NSDictionary *dictionary in services) {
            NSString *type = dictionary[@"typename"];
            [servertype addObject:type];
        }
        
        NSString *showserver = [servertype componentsJoinedByString:@"   "];
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [NSString stringWithFormat:@"服务类型:   %@", showserver];
        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
        [view setBackgroundColor:XMGlobalBg];
        
        UIButton *editShop = [UIButton buttonWithType:UIButtonTypeCustom];
        [editShop setFrame:CGRectMake(20, 30, kDeviceWidth - 40, 44)];
        [editShop setTitle:@"编辑店铺" forState:UIControlStateNormal];
        [editShop setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
        [editShop addTarget:self action:@selector(buttonClickToEditShopInfo) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:editShop];
        return view;
        
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        XMDevoteController *devoteController = [[XMDevoteController alloc] init];
        devoteController.maintainer_id = self.shopDetail.maintainer_id;
        devoteController.navigationItem.title = @"修神详情";
        [self.navigationController pushViewController:devoteController animated:YES];
        
    }else if (indexPath.section == 1){
        
        XMRatingListViewController *ratingListViewController = [[XMRatingListViewController alloc] init];
        ratingListViewController.maintainer_id = self.shopDetail.maintainer_id;
        [self.navigationController pushViewController:ratingListViewController animated:YES];
        
    }else if (indexPath.section == 2){
        
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return FLT_MIN;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }else if (indexPath.section == 1){
        return 80;
    }else if (indexPath.section == 2){
        return 200;
    }else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}
#pragma mark - 顶部照片墙
//加载顶部照片墙
- (void)loadHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDetailPhotoHeight)];
    _tableView.tableHeaderView = _headView;
    //滑动视图
    _topScrollView = [[UIScrollView alloc] initWithFrame:_headView.bounds];
    _topScrollView.contentMode = UIViewContentModeScaleAspectFill;
    _topScrollView.pagingEnabled = YES;
    _topScrollView.delegate = self;
    _topScrollView.showsHorizontalScrollIndicator = NO;
    [_headView addSubview:_topScrollView];
    
    _arrayImage = self.shopDetail.maintainphoto;
    if ([_arrayImage isKindOfClass:[NSArray class]] && _arrayImage.count) {
        for (int i=0; i<_arrayImage.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*_headView.width, 0, _headView.width, _headView.height)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            NSDictionary *file = _arrayImage[i];
            [imageView setImageWithURL:[NSURL URLWithString:file[@"photo"]]];
            [_topScrollView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            _topScrollView.delegate = self;
            //为照片请添加手势
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)]];
        }
        _topScrollView.contentSize = CGSizeMake(_headView.width*_arrayImage.count, 0);
        
        //
        _currentIndex = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-50, _headView.height-50, 40, 40)];
        _currentIndex.layer.cornerRadius = 20;
        _currentIndex.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)_arrayImage.count];
        _currentIndex.layer.borderColor = [UIColor whiteColor].CGColor;
        _currentIndex.layer.borderWidth = 2;
        _currentIndex.textColor = [UIColor whiteColor];
        _currentIndex.textAlignment = NSTextAlignmentCenter;
        [_headView addSubview:_currentIndex];
    }else{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _headView.width, _headView.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImage:[UIImage imageNamed:@"01.jpg"]];
        [_topScrollView addSubview:imageView];
    }
}

#pragma mark - 点击照片墙上照片
- (void)clickImage:(UITapGestureRecognizer *)tap
{
    XMLog(@"%i",(int)(_topScrollView.contentOffset.x/self.view.width));
    
    XMAlbumViewController *albumVC = [[XMAlbumViewController alloc] init];
    albumVC.array = _arrayImage;
    albumVC.index = (int)(_topScrollView.contentOffset.x/kDeviceWidth);
    albumVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:albumVC animated:YES completion:^{}];
}

#pragma mark - 滑动视图代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_topScrollView == nil) {
        return;
    }
    if (scrollView == _topScrollView) {
        _currentIndex.text = [NSString stringWithFormat:@"%li/%lu",(NSInteger)(_topScrollView.contentOffset.x/_topScrollView.width)+1,(unsigned long)_arrayImage.count];
    }
}



- (void)notHaveShopView:(JHNotHaveShopView *)notHaveShopView didClicked:(NSString *)tishi
{
    if ([[UserDefaults objectForKey:@"approve"] integerValue] == 0) {
        
        XMLoginViewController *loginViewController = [[XMLoginViewController alloc] init];
        loginViewController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:loginViewController animated:YES];
        
    }else{
        
        JHNewSetShopViewController *newSetShopViewController = [[JHNewSetShopViewController alloc] init];
        
        
        [self.navigationController pushViewController:newSetShopViewController animated:YES];
        
    }
    
    
}

- (void)buttonClickToEditShopInfo
{
    JHEditShopInfoViewController *editShopInfoViewController = [[JHEditShopInfoViewController alloc] init];
    [self.navigationController pushViewController:editShopInfoViewController animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"------我的店铺内存有问题！------------");
}

- (void)dealloc
{
    [_topScrollView removeFromSuperview];
    _topScrollView.delegate = nil;
    _topScrollView = nil;
    
    _tableView.delegate = nil;
    [_tableView removeFromSuperview];
    _tableView = nil;
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
