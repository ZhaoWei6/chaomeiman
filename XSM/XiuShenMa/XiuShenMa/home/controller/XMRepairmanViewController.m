//
//  XMRepairmanViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRepairmanViewController.h"
#import "XMRepairmanCell.h"
#import "XMRepairDetailViewController.h"
#import "XMMapViewController.h"
#import "XMDealTopMenu.h"
#import "XMMainViewController.h"

#import "MJRefresh.h"
#import "XMImageTool.h"

#import "XMMetaDataTool.h"
#import "XMDealTool.h"
#import "XMRepairman.h"
#import "QHTopMenu.h"

//#import "UIView+Shadow.h"

#define kSpan MKCoordinateSpanMake(0.018404, 0.031468)
//自定义一个按钮类
@interface ReorderItem : UIButton
@end

@implementation ReorderItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kRepairTextFont;
        // 2.右侧分隔线
        UIImageView *divider = [[UIImageView alloc] init];
        divider.backgroundColor = kBorderColor;
        divider.bounds = CGRectMake(0, 0, 1, self.height * 0.5);
        divider.center = CGPointMake(self.width, self.height * 0.5);
        [self addSubview:divider];
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = contentRect.size.height * 0.1;
    CGFloat h = contentRect.size.height * 0.8;
    CGFloat w = contentRect.size.width;
    return CGRectMake(0, y, w, h);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = contentRect.size.height - 1.5;
    CGFloat w = contentRect.size.width * 0.7;
    CGFloat x = (contentRect.size.width - w)/2;
    return CGRectMake(x, h, w, 2);
}
@end

#pragma mark -
@interface XMRepairmanViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MJRefreshBaseViewDelegate,UIGestureRecognizerDelegate,QHTopMenuItemClickDelegete>
{
    UIView *_headView;
    UITableView *_tableView;
    CLLocationManager *locationManager;//定义Manager
    
    UIView *addressView;//
    UIButton *refreshButton;//位置刷新按钮
    UIActivityIndicatorView *indicator;//刷新指示器
    UILabel *addressLabel;//位置标签
    
    NSMutableArray *_deals;
    int _page; // 页码
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;

@end

@implementation XMRepairmanViewController

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = @"fa1d05282382b78d61e0ed999496de73";
    self.mapView = [[MAMapView alloc] init];
    self.mapView.frame = self.view.bounds;
    self.mapView.hidden = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    self.mapView.showsUserLocation = YES;
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"fa1d05282382b78d61e0ed999496de73" Delegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [XMDealTool sharedXMDealTool].itemcategoryid = _itemcategory;
    //
    [self initMapView];
    //
    [self initNavigationItem];
    //
    [self initHeadView];
    //
    [self initTableView];
    //
    [self addRefresh]; 
    
    //
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager requestAlwaysAuthorization];
    }
    
    //
    if ([XMDealTool sharedXMDealTool].currentLatitude && [XMDealTool sharedXMDealTool].currentLongitude) {
        indicator.alpha = 0;
        addressLabel.text = [NSString stringWithFormat:@"当前位置：%@%@",[XMDealTool sharedXMDealTool].area,[XMDealTool sharedXMDealTool].address];
        [_header beginRefreshing];
    }else{
        indicator.alpha = 1;
        [self refreshAddress];
    }
}
#pragma mark 导航栏按钮
- (void)initNavigationItem
{
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 25, 25);
//    [rightButton setImage:[UIImage resizedImage:@"icon_map"] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(clickItem) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_map"] style:UIBarButtonItemStylePlain target:self action:@selector(clickItem)];
}
#pragma mark 选项菜单
- (void)initHeadView
{
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kRepairHeadViewHeight)];
    _headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headView];
    [self.view bringSubviewToFront:_headView];
    //
    [self addReorderItem];
    //
    [self addAddressLabel];
}
#pragma mark 添加顶部排序项
- (void)addReorderItem
{
    NSArray *titles = @[@"离我最近",@"修理最多",@"评价最高"];
    QHTopMenu *topMenu = [QHTopMenu initQHTopMenuWithTitles:titles frame:CGRectMake(0, 0, kDeviceWidth, 44) delegate:self];
    [_headView addSubview:topMenu];
    /*
    for (int i=0;i<titles.count;i++) {
        ReorderItem *orderItem = [[ReorderItem alloc] initWithFrame:CGRectMake(kDeviceWidth/3*i, 0, kDeviceWidth/3, 44)];
        [orderItem setTitleColor:XMButtonBg forState:UIControlStateDisabled];
        [orderItem setTitleColor:kTextFontColor333 forState:UIControlStateNormal];
        [orderItem setTitle:titles[i] forState:UIControlStateNormal];
        orderItem.tag = 100+i;
        [orderItem addTarget:self action:@selector(orderItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:orderItem];
        //默认选中第一个按钮-----离我最近
        if (i==0) {
            [self orderItemClick:orderItem];
        }
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 42, kDeviceWidth/3, 2)];
    bottomLine.backgroundColor = XMButtonBg;
    bottomLine.tag = 1;
    [_headView addSubview:bottomLine];
     */
}
#pragma mark QHTopMenuItemClickDelegete
- (void)clickItemWithItem:(NSString *)item
{
    if ([item isEqualToString:@"离我最近"]) {
        _orderby = 0;
    }else if ([item isEqualToString:@"修理最多"]){
        _orderby = 1;
    }else{
        _orderby = 2;
    }
    if (_header.isRefreshing || _footer.isRefreshing) {
        [_header endRefreshing];
        [_footer endRefreshing];
    }
    [_header beginRefreshing];
}
#pragma mark 位置标签
- (void)addAddressLabel
{
    //位置
    addressView = [[UIView alloc] initWithFrame:CGRectMake(0, kRepairHeadViewHeight-30, kDeviceWidth, 30)];
    [addressView makeInsetShadowWithRadius:0.5 Color:kBorderColor Directions:@[@"bottom"]];
    addressView.backgroundColor = XMColor(240, 239, 237);
    [_headView addSubview:addressView];
    //地理位置信息标签
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kDeviceWidth, addressView.height)];
    addressLabel.textColor = kTextFontColor999;
    addressLabel.tag = 1001;
    addressLabel.text = @"正在获取您的地理位置...";
    addressLabel.font = kRepairTextFont;
    [addressView addSubview:addressLabel];
    //位置刷新按钮
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(addressView.right - 40, addressLabel.top+2, 25, 25);
    [refreshButton setImage:[UIImage imageWithName:@"refresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshAddress) forControlEvents:UIControlEventTouchUpInside];
    refreshButton.tag = 1002;
    [addressView addSubview:refreshButton];
    //指示器
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = refreshButton.frame;
    [addressView addSubview:indicator];
    [indicator startAnimating];
}
#pragma mark 表格
- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.bottom, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithHexString:@"#CCCCCC"];
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.backgroundColor = XMGlobalBg;
    [self followScrollView:_tableView];
    _tableView.rowHeight = 123;
    [self setExtraCellLineHidden:_tableView];
    [_tableView registerClass:[XMRepairmanCell class] forCellReuseIdentifier:@"cell"];
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
#pragma mark - 获取当前位置信息
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    [XMDealTool sharedXMDealTool].currentLongitude = userLocation.coordinate.longitude;
    [XMDealTool sharedXMDealTool].currentLatitude = userLocation.coordinate.latitude;
    XMLog(@"%@",userLocation.location);
    [self searchReGeocode:userLocation.location];
}
- (void)searchReGeocode:(CLLocation*)location
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
//    NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
    AMapAddressComponent *address = response.regeocode.addressComponent;
    _area = [NSString stringWithFormat:@"%@%@%@",address.province,address.city,address.district];
    _address = [NSString stringWithFormat:@"%@",address.township];
    XMLog(@"当前地址: %@", _address);
    [XMDealTool sharedXMDealTool].area = _area;
    [XMDealTool sharedXMDealTool].address = _address;
    addressLabel.text = [NSString stringWithFormat:@"当前位置：%@%@",self.area,self.address];
    refreshButton.hidden = NO;
    indicator.alpha = 0;
    //3.获取数据
    [_header beginRefreshing];
}

#pragma mark - 表格方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deals.count;
}

- (XMRepairmanCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMRepairmanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.repairman = _deals[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMRepairDetailViewController *detailVC = [[XMRepairDetailViewController alloc] init];
//    detailVC.maintainer_id = _deals[indexPath.row];
    XMRepairman *repair = _deals[indexPath.row];
    detailVC.maintainer_id = repair.maintainer_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 160;
//}

#ifdef iOS8
-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
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

//设置当单元格中无数据时隐藏分隔线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}
#pragma mark - 刷新代理方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    BOOL isHeader = [refreshView isKindOfClass:[MJRefreshHeaderView class]];
    if (isHeader) { // 下拉刷新
        // 清除图片缓存
        [XMImageTool clear];
        _page = 1; // 第一页
    } else { // 上拉加载更多
        _page++;
        [XMImageTool clear];
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(endRefreshList) userInfo:nil repeats:NO];
    // 加载第_page页的数据
    [[XMDealTool sharedXMDealTool] dealsWithPage:_page itemCategory:_itemcategory orderby:_orderby success:
     ^(NSArray *deals , int islast) {
         [timer invalidate];
         
         if (isHeader) {
             _deals = [NSMutableArray array];
         }
         // 1.添加数据
         [_deals addObjectsFromArray:deals];
         
         if ([_deals isKindOfClass:[NSMutableArray class]] && _deals.count) {
             [self removeImage];
             // 2.刷新表格
             [_tableView reloadData];
         }else{
             [self removeImage];
             [self showOerderNone];
         }
         
         // 3.恢复刷新状态
         [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
         
         _footer.hidden = islast;
     }];
}
- (void)endRefreshList
{
    [_header endRefreshing];
    [_footer endRefreshing];
    [MBProgressHUD showError:@"网络不给力！"];
}
#pragma mark - 没修神
- (void)showOerderNone
{
    _tableView.hidden = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kDeviceWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kTextFontColor666;
    label.text = @"没有发现修神";
    label.tag = 2001;
    [self.view addSubview:label];
}
- (void)removeImage
{
    _tableView.hidden = NO;
    UILabel *label = (UILabel *)[self.view viewWithTag:2001];
    if (label) {
        [label removeFromSuperview];
        label = nil;
    }
}
#pragma mark - 按钮点击事件
//导航栏右侧翻转地图按钮
- (void)clickItem
{
    XMMapViewController *mapVC = [[XMMapViewController alloc] init];
    mapVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:mapVC animated:YES completion:nil];
}
//点击顶部刷新当前位置按钮
- (void)refreshAddress
{
    addressLabel.text = @"正在获取您的地理位置...";
    indicator.alpha = 1;
    refreshButton.hidden = YES;
    [self.mapView setShowsUserLocation:YES];
}

- (void)orderItemClick:(ReorderItem *)item
{
    item.enabled = NO;
    for (int i=0; i<3; i++) {
        ReorderItem *reorderItem = (ReorderItem *)[_headView viewWithTag:100+i];
        if (reorderItem.tag == item.tag) {
            
        }else{
            reorderItem.enabled = YES;
        }
    }
    UIView *bottomLine = [[item superview] viewWithTag:1];
    _orderby = item.tag-100;
    [self moveBottomLine:bottomLine to:_orderby];
    
    
    [_header beginRefreshing];
}
//移动选项底部的线
- (void)moveBottomLine:(UIView *)bottomLine to:(NSInteger)to
{
    CGRect frame = bottomLine.frame;
    frame.origin.x = kDeviceWidth/3*to;
    [UIView animateWithDuration:0.2 animations:^{
        bottomLine.frame = frame;
    }];
}

#pragma mark - 显示隐藏顶部菜单
- (void)followScrollView:(UIView*)scrollableView
{
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
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
        if ([self.scrollableView isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)self.scrollableView setContentOffset:CGPointMake(((UIScrollView*)self.scrollableView).contentOffset.x, ((UIScrollView*)self.scrollableView).contentOffset.y - delta)];
        }
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
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
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
            
            // This line needs tweaking
            // [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y - delta) animated:YES];
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
    [self.overlay setAlpha:1 - alpha];
    _headView.tintColor = [_headView.tintColor colorWithAlphaComponent:alpha];
    
    frame = _tableView.frame;
    frame.origin.y = _headView.frame.origin.y + kRepairHeadViewHeight;
//    if (_tableView.frame.origin.y == 64) {
        frame.size.height = kDeviceHeight-64;
//    }else{
//        frame.size.height = kDeviceHeight-kRepairHeadViewHeight-64;
//    }
    _tableView.frame = frame;
    
    // Changing the layer's frame avoids UIWebView's glitchiness
//    frame = self.scrollableView.layer.frame;
//    frame.size.height += delta;
//    _tableView.frame = frame;
}
- (void)dealloc
{
    _header = nil;
    _footer = nil;
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _tableView = nil;
}

@end









