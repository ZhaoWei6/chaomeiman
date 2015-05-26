//
//  XMAlbumViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-9.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAlbumViewController.h"

#define kScrollViewGap 15

@interface XMAlbumViewController ()
{
    UILabel *currentIndex;
}
@end

@implementation XMAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kRectEdge
    kNAVITAIONBACKBUTTON
    // 创建滑动视图
    [self loadBaseScrollView];
    
    currentIndex = [[UILabel alloc] init];
    [self.view addSubview:currentIndex];
    currentIndex.backgroundColor = [UIColor grayColor];
    currentIndex.alpha = 0.8;
    
    currentIndex.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:currentIndex attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeRight constant:-60];
    [UIView setView:currentIndex attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:-20];
    [UIView setView:currentIndex attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeTop constant:40];
    [UIView setView:currentIndex attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeTop constant:80];
    
    currentIndex.textAlignment = NSTextAlignmentCenter;
    currentIndex.text = [NSString stringWithFormat:@"%i/%i",(NSInteger)(_contentScrollView.contentOffset.x/_contentScrollView.width)+1,_array.count];
    currentIndex.layer.cornerRadius = 20;
    currentIndex.layer.masksToBounds = YES;
    
    if (_array.count<=1) {
        currentIndex.hidden = YES;
    }
}

- (void)loadBaseScrollView
{
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    _contentScrollView.tag = INT_MAX;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshUI];
    self.navigationController.navigationBarHidden = YES;
    _contentScrollView.contentOffset = CGPointMake(_index*kDeviceWidth, 0);
}
- (void)refreshUI
{
    int width = 0;
    for (int index = 0; index < _array.count; index++) {
        // 创建视图
        AblumView *ablumView = [[AblumView alloc] initWithFrame:CGRectMake(0+width, 0, kDeviceWidth, kDeviceHeight)];
        ablumView.tag = index;
        ablumView.imageName = _array[index][@"photo"];
        [ablumView downloadImage];
        ablumView.delegate = self;
        [_contentScrollView addSubview:ablumView];
        width += kDeviceWidth;
    }
    // 设置滑动视图的内容大小
    _contentScrollView.contentSize = CGSizeMake(width, 0);
}

- (void)downloadData:(NSInteger)i
{
    AblumView *_ablumView = (AblumView *)[_contentScrollView viewWithTag:i];
    _ablumView.imageName = _array[i][@"photo"];
    [_ablumView downloadImage];
}

#pragma mark - ScrollView Delegate
static int lastIndex = 0;//记录上一个相册视图的索引值
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scroll
{
    int index = scroll.contentOffset.x / kDeviceWidth;
    
    if (index >= _array.count || index < 0) {
        return;
    }
    // 还原上一个视图比例
    AblumView *ablumView = (AblumView *)[_contentScrollView viewWithTag:lastIndex];
    CGFloat zoom = ablumView.ablumScrollView.zoomScale;
    if (zoom >= 1 && lastIndex != index) {
        ablumView.ablumScrollView.zoomScale = 1;
    }
//    XMLog(@"滑动了视图");
    lastIndex = index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    currentIndex.text = [NSString stringWithFormat:@"%i/%i",(NSInteger)(_contentScrollView.contentOffset.x/_contentScrollView.width)+1,_array.count];
}

#pragma mark - AblumView Delegate
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    self.navigationController.navigationBarHidden = NO;
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
