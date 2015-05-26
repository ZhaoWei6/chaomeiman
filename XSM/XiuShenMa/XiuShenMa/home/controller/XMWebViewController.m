//
//  XMWebViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMWebViewController.h"

@interface XMWebViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIView *_cover;
}
@end

@implementation XMWebViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor = [UIColor lightGrayColor];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    kRectEdge
    // 1.加载请求
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    // 2.添加遮盖
    _cover = [[UIView alloc] init];
    _cover.frame = _webView.bounds;
    _cover.backgroundColor = XMGlobalBg;
    _cover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webView addSubview:_cover];
    
    // 3.添加圈圈
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    CGFloat x = _cover.frame.size.width * 0.5;
    CGFloat y = _cover.frame.size.height * 0.5;
    indicator.center = CGPointMake(x, y);
    [_cover addSubview:indicator];
    [indicator startAnimating];
    
    // 4.加载底部工具栏
    [self loadToolBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

//底部工具栏
- (void)loadToolBar
{
    UIView *toolBar = [[UIView alloc] init];
    toolBar.backgroundColor = XMGlobalBg;
    [self.view addSubview:toolBar];
    
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [UIView setView:toolBar attr:NSLayoutAttributeLeft sAttr:NSLayoutAttributeLeft constant:0];
    [UIView setView:toolBar attr:NSLayoutAttributeRight sAttr:NSLayoutAttributeRight constant:0];
    [UIView setView:toolBar attr:NSLayoutAttributeTop sAttr:NSLayoutAttributeBottom constant:-44];
    [UIView setView:toolBar attr:NSLayoutAttributeBottom sAttr:NSLayoutAttributeBottom constant:0];
    
    UIButton *backBtn = [self loadButtonWithTitle:@"返回" index:0];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backBtn];
    
    UIButton *button_go_back = [self loadButtonWithTitle:@"后退" index:1];
    [button_go_back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:button_go_back];
    
    UIButton *button_go_forward = [self loadButtonWithTitle:@"前进" index:2];
    [button_go_forward addTarget:self action:@selector(forward) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:button_go_forward];
}

#pragma mark - 请求加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 移除遮盖
    [_cover removeFromSuperview];
    _cover = nil;
    
}
#pragma mark -
- (UIButton *)loadButtonWithTitle:(NSString *)title index:(NSInteger )index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kDeviceWidth*index/3, 0, kDeviceWidth/3, 44);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (void)backButtonClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)back
{
    [_webView goBack];
}
- (void)forward
{
    [_webView goForward];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
