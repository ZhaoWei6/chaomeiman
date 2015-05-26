//
//  XMRepairmanListViewController.m
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRepairmanListViewController.h"
#import "ReorderItem.h"
#import "RepairmanCell.h"
#import "MJRefresh.h"
#import "XMShopDetailViewController.h"
#import "XMMapViewController.h"
#import "XMRepairman.h"
#import "JHRepairmanCell.h"

@interface XMRepairmanListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UIGestureRecognizerDelegate>
{
    ReorderItem *selectItem;//选中排序
    NSMutableArray *_deals;//内容
    int _page; // 页码
    
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (assign, nonatomic) float lastContentOffset;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;

- (IBAction)refreshUserLocation:(UIButton *)sender;
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender;


@end

@implementation XMRepairmanListViewController

NSString *identifier = @"RepairmanCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [XMDealTool sharedXMDealTool].itemcategoryid = _itemcategory;
    //
    [self initMapView];
    //
    [self initNavigationItem];
    //
    [self loadDivider];
    //
    self.tableView.backgroundColor = XMGlobalBg;
    // 1.注册一个单元格
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
    
    [self.tableView setSeparatorColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]];
    
    NSString *area = [XMDealTool sharedXMDealTool].area;
    NSString *address = [XMDealTool sharedXMDealTool].address;
    if ([area isKindOfClass:[NSString class]] && ![area isEqualToString:@""]) {
        self.addressLabel.text = [NSString stringWithFormat:@"  当前位置：%@%@",area,address];
    }else{
        if (selectItem == nil) {
            selectItem = _orderItem0;
        }
        [self initUserLocation];
    }
    
    // 2.添加刷新控件
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *area = [XMDealTool sharedXMDealTool].area;
//    NSString *address = [XMDealTool sharedXMDealTool].address;
//    if ([area isKindOfClass:[NSString class]] && ![area isEqualToString:@""]) {
//        self.addressLabel.text = [NSString stringWithFormat:@"  当前位置：%@%@",area,address];
////        if (_tableView.numberOfSections) {
////            [_header beginRefreshing];
////        }else{
////            [self changeOrder:_orderItem0];
////        }
//    }else{
//        if (selectItem == nil) {
//            selectItem = _orderItem0;
//        }
//        [self initUserLocation];
//    }
}
#pragma mark 初始化一个地图，用于定位
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = @"719d9ded1b88ed3810744274293ea376";
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.hidden = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
}
#pragma mark - 设置导航栏按钮
- (void)initNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStylePlain target:self action:@selector(goToMapViewController)];
}

#pragma mark - 表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XMLog(@"_deals.count=%li",_deals.count);
    return _deals.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    RepairmanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    XMRepairman *repairman = _deals[indexPath.row];
//    cell.repairman = repairman;
//    cell.backgroundColor = XMGlobalBg;
//    return cell;

    JHRepairmanCell *cell = [JHRepairmanCell repairmanCellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = XMGlobalBg;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    XMRepairman *repairman = _deals[indexPath.row];
    cell.repairman = repairman;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMShopDetailViewController *shopDetailVC = [[XMShopDetailViewController alloc] initWithNibName:@"XMShopDetailViewController" bundle:nil];
    XMRepairman *repairman = _deals[indexPath.row];
    shopDetailVC.maintainer_id = repairman.maintainer_id;
    [self.navigationController pushViewController:shopDetailVC animated:YES];
}
#pragma mark -
#pragma mark 定位
- (void)initUserLocation
{
    self.addressLabel.text = @"  正在获取您的位置...";
    self.refreshButton.hidden = YES;
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    
    self.mapView.showsUserLocation = YES;
}
#pragma mark - 获取当前位置信息
- (void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [XMDealTool sharedXMDealTool].currentLatitude = userLocation.coordinate.latitude;
        [XMDealTool sharedXMDealTool].currentLongitude = userLocation.coordinate.longitude;
        
        //
        [self changeOrder:selectItem];
        
        [self searchReGeocode:userLocation];
    }
}
- (void)searchReGeocode:(MAUserLocation*)location
{
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = NO;
    [self.search AMapReGoecodeSearch: regeoRequest];
}
#pragma mark 查询回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    [self.mapView setShowsUserLocation:NO];
    AMapAddressComponent *address = response.regeocode.addressComponent;
    NSString *area = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.district];
    NSString *add = [NSString stringWithFormat:@"%@",address.township];
    NSLog(@"当前地址-->区域%@->%@",area,add);
    
    self.addressLabel.text = [NSString stringWithFormat:@"  当前位置：%@%@",area,add];
    self.refreshButton.hidden = NO;
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}
#pragma mark 添加刷新控件
- (void)addRefresh
{
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    header.delegate = self;
    _header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.delegate = self;
    _footer = footer;
}
#pragma mark - 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    BOOL isHeader = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
    if (isHeader) { // 下拉刷新
        _page = 1; // 第一页
    } else { // 上拉加载更多
        _page++;
    }
    
    // 加载第_page页的数据
    [[XMDealTool sharedXMDealTool] dealsWithPage:_page itemCategory:_itemcategory orderby:_orderby success:
     ^(NSArray *deals , int islast) {
         if (isHeader) {
             _deals = [NSMutableArray array];
         }
         // 1.添加数据
         [_deals addObjectsFromArray:deals];
         
         // 2.刷新表格
         [_tableView reloadData];
         
         // 3.恢复刷新状态
         [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
         
         _footer.hidden = islast;
     }];
}
#pragma mark - 进地图
- (void)goToMapViewController
{
    XMMapViewController *mapVC = [[XMMapViewController alloc] init];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:mapVC animated:YES completion:nil];
}

#pragma mark -
//分割线
- (void)loadDivider
{
    UIImageView *divider1 = [[UIImageView alloc] init];
    divider1.backgroundColor = kBorderColor;
    divider1.bounds = CGRectMake(0, 0, 1, 44 * 0.5);
    divider1.center = CGPointMake(kDeviceWidth/3-0.5, 44 * 0.5);
    [_headView addSubview:divider1];
    
    UIImageView *divider2 = [[UIImageView alloc] init];
    divider2.backgroundColor = kBorderColor;
    divider2.bounds = CGRectMake(0, 0, 1, 44 * 0.5);
    divider2.center = CGPointMake(kDeviceWidth*2/3-0.5, 44 * 0.5);
    [_headView addSubview:divider2];
}
#pragma mark - 排序
- (IBAction)changeOrder:(ReorderItem *)sender {
//    XMLog(@"点击排序按钮");
    selectItem.enabled = YES;
    sender.enabled = NO;
    selectItem = sender;
    
    if ([sender.titleLabel.text isEqualToString:@"离我最近"]) {
        XMLog(@"离我最近");
        _orderby = 0;
        [_header beginRefreshing];
    }else if ([sender.titleLabel.text isEqualToString:@"修理最多"]){
        XMLog(@"修理最多");
        _orderby = 1;
        [_header beginRefreshing];
    }else{
        XMLog(@"评分最高");
        _orderby = 2;
        [_header beginRefreshing];
    }
}
#pragma mark - 刷新位置
- (IBAction)refreshUserLocation:(UIButton *)sender {
    [self initUserLocation];
}

#pragma mark -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    
//    XMLog(@"%f",self.lastContentOffset);
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    CGRect frame;
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }
        
        frame = _headView.frame;
        
        if (frame.origin.y - delta < (64-kRepairHeadViewHeight)) {
            delta = frame.origin.y + (kRepairHeadViewHeight-64);
        }
        
        frame.origin.y = MAX((64-kRepairHeadViewHeight), frame.origin.y - delta);
        _headView.frame = frame;
        
        if (frame.origin.y == (64-kRepairHeadViewHeight)) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }
        
        [self updateSizingWithDelta:delta];
        
        // Keeps the view's scroll position steady until the navbar is gone
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - delta)];
    }

    if (delta < 0) {
        if (self.isExpanded) {
            return;
        }
        
        frame = _headView.frame;
        
        if (frame.origin.y - delta > 64) {
            delta = frame.origin.y - 64;
        }
        frame.origin.y = MIN(64, frame.origin.y - delta);
        _headView.frame = frame;
        
        if (frame.origin.y == 64) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        // Reset the nav bar if the scroll is partial
        self.lastContentOffset = 0;
        [self checkForPartialScroll];
    }
}
- (void)checkForPartialScroll
{
    CGFloat pos = _headView.frame.origin.y;
    
    // Get back down
    if (pos >= -2) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = _headView.frame;
            CGFloat delta = frame.origin.y - 64;
            frame.origin.y = MIN(64, frame.origin.y - delta);
            _headView.frame = frame;
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self updateSizingWithDelta:delta];
        }];
    } else {
        // And back up
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame;
            frame = _headView.frame;
            CGFloat delta = frame.origin.y + (kRepairHeadViewHeight-64);
            frame.origin.y = MAX((64-kRepairHeadViewHeight), frame.origin.y - delta);
            _headView.frame = frame;
            
            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            [self updateSizingWithDelta:delta-18];
        }];
    }
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    CGRect frame = _headView.frame;
    
    float alpha = (frame.origin.y + (kRepairHeadViewHeight-64)) / frame.size.height;
//    [self.overlay setAlpha:1 - alpha];
    _headView.tintColor = [_headView.tintColor colorWithAlphaComponent:alpha];
    
    frame = _tableView.frame;
    frame.origin.y = _headView.frame.origin.y + kRepairHeadViewHeight;
//    frame.size.height
//    if (_tableView.frame.origin.y == 64) {
        frame.size.height = kDeviceHeight-64;
//    }else{
//        frame.size.height = kDeviceHeight-kRepairHeadViewHeight-64;
//    }
    _tableView.frame = frame;
}

#ifdef iOS8
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#else

#endif

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
