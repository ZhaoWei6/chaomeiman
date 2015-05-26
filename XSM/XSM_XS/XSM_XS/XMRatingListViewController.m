//
//  XMRatingListViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/14.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMRatingListViewController.h"
#import "XMDealTool.h"
#import "XMRatingView.h"
#import "XMRatingRepair.h"

#import "MJRefresh.h"
#import "XMRatingListCell.h"

@interface XMRatingListViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_deals;
    
    UILabel *_phoneLabel;
    XMRatingView *_ratingView;
    UILabel *_ratingTimeLabel;
    UILabel *_ratingContentLabel;
    
    
    int _page; // 页码
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}
@end

@implementation XMRatingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价列表";
    [self loadSubViews];
    
    [self addRefresh];
    
    [_header beginRefreshing];
}

- (void)loadSubViews
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    //单元格分隔线
    [self setExtraCellLineHidden:_tableView];
    
    //行高
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *nib = [UINib nibWithNibName:@"XMRatingListCell" bundle:nil];
    [_tableView registerNib:nib forCellReuseIdentifier:@"CustomCell"];
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
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (!_isRepair) {
        [params setObject:@(_page) forKey:@"page"];
        [params setObject:_maintainer_id forKey:@"maintainer_id"];
    }else{
        [params setObject:@(_page) forKey:@"page"];
        [params setObject:@(1) forKey:@"type"];
        [params setObject:[UserDefaults objectForKey:@"userid"] forKey:@"userid"];
        [params setObject:[UserDefaults objectForKey:@"password"] forKey:@"password"];
    }
    
    // 加载第_page页的数据
    [[XMDealTool sharedXMDealTool] evaluatelistWithParams:params success:^(NSArray *deals, int islast) {
        if (isHeader) {
            _deals = [NSMutableArray array];
        }
        // 1.添加数据
        [_deals addObjectsFromArray:deals];
        
        if ([_deals isKindOfClass:[NSMutableArray class]] && _deals.count) {
            [self removeImage];
            // 2.刷新表格
            [_tableView reloadData];
            _tableView.hidden = NO;
        }
        else{
            // 没有评论  提示修神
            [self removeImage];
            [self performSelector:@selector(showOerderNone) withObject:nil afterDelay:0.51];
        }
        
        // 2.刷新表格
        [_tableView reloadData];
        _tableView.hidden = NO;
        // 3.恢复刷新状态
        [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.5];
        
        _footer.hidden = islast;
    }];
}
#pragma mark - 没评论
- (void)showOerderNone
{
    _tableView.hidden = YES;
    //    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64+44, kDeviceWidth, kDeviceHeight-64-44-49)];
    //    [image setImage:[UIImage imageNamed:@"order_none"]];
    //    image.tag = 101;
    //    image.contentMode = UIViewContentModeScaleAspectFit;
    //    [self.view addSubview:image];
    UILabel *message = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, 30)];
    message.center = self.view.center;
    [message setText:@"该修神还没有评论"];
    message.textColor = kTextFontColor666;
    message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:message];
    message.tag = 101;
}
- (void)removeImage
{
    _tableView.hidden = NO;
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
- (void)initRatingListNone
{
    _tableView.hidden = YES;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((kDeviceWidth-100)/2.0, 84, 100, 100)];
    image.image = [UIImage imageNamed:@"logo"];
    image.tag = 101;
    [self.view addSubview:image];
    image.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.bottom+20, kDeviceWidth, 20)];
    label.tag = 102;
    label.text = @"暂无评价！";
    label.textColor = kTextFontColor666;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}
- (void)removeRatingListNone
{
    UIImageView *image = (UIImageView *)[self.view viewWithTag:101];
    UILabel     *label = (UILabel     *)[self.view viewWithTag:102];
    
    [image removeFromSuperview];
    [label removeFromSuperview];
    
    image = nil;
    label = nil;
}
#pragma mark - 表格方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deals.count;
}
- (XMRatingListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMRatingRepair *repair = _deals[indexPath.row];
    
    XMRatingListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    cell.repair = repair;
    
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iOS8) {
        return -1;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
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

- (void)dealloc
{
    _header = nil;
    _footer = nil;
}

@end
