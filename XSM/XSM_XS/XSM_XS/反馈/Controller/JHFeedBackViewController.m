//
//  JHFeedBackViewController.m
//  XSM_XS
//
//  Created by Andy on 15/1/6.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#define AppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBridgingRelease(kCFBundleVersionKey)]


#import "JHFeedBackViewController.h"
#import "XMLoginViewController.h"
#import "XMUserResponseViewController.h"
#import "XMDealTool.h"
#import "JHSingleBar.h"
#import "JHPieChartBar.h"

@interface JHFeedBackViewController ()<JHSingleBarDelegate>

/** 遮盖 */
@property (nonatomic, weak) UIButton *cover;
@property (nonatomic, weak) UIButton *pieCover;
@property (nonatomic, strong) JHSingleBar *singleBar;
@property (nonatomic, strong) JHPieChartBar *pieChartBar;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthButton;
@property (weak, nonatomic) IBOutlet UIButton *feedBackButton;

@property (nonatomic, strong) NSArray *moodArray;
@property (nonatomic, strong) NSArray *nowArray;
@property (nonatomic, strong) NSArray *hopeArray;

@end

@implementation JHFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.firstButton setExclusiveTouch:YES];
    [self.secondButton setExclusiveTouch:YES];
    [self.thirdButton setExclusiveTouch:YES];
    [self.fourthButton setExclusiveTouch:YES];
    [self.feedBackButton setExclusiveTouch:YES];
    
    [self setupNavigationView];
    [self requestDataForFourPage];
    [self testRunSomeEquipment];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

/** 初始化导航栏 */
- (void)setupNavigationView
{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem setTitle:@"四格体验"];
}


/** 适配3.5寸屏幕 */
- (void)testRunSomeEquipment
{
    if (kDeviceHeight == 480) {
        
        CGFloat inter = 85;
        CGRect title_frame = self.titleImageView.frame;
        CGRect first_frame = self.firstButton.frame;
        CGRect second_frame = self.secondButton.frame;
        CGRect third_frame = self.thirdButton.frame;
        CGRect fourth_frame = self.fourthButton.frame;
        CGRect feed_frame = self.feedBackButton.frame;
        
        self.titleImageView.frame = CGRectMake(title_frame.origin.x, title_frame.origin.y - inter, title_frame.size.width, title_frame.size.height);
        self.firstButton.frame = CGRectMake(first_frame.origin.x, first_frame.origin.y - inter, first_frame.size.width, first_frame.size.height);
        self.secondButton.frame = CGRectMake(second_frame.origin.x, second_frame.origin.y - inter, second_frame.size.width, second_frame.size.height);
        self.thirdButton.frame = CGRectMake(third_frame.origin.x, third_frame.origin.y - inter, third_frame.size.width, third_frame.size.height);
        self.fourthButton.frame = CGRectMake(fourth_frame.origin.x, fourth_frame.origin.y - inter, fourth_frame.size.width, fourth_frame.size.height);
        self.feedBackButton.frame = CGRectMake(feed_frame.origin.x, feed_frame.origin.y - inter, feed_frame.size.width, feed_frame.size.height);
        
    }else{
        
        CGFloat intervel = kDeviceWidth/32;
        CGFloat title_y = 64 + intervel;
        CGFloat title_w = kDeviceWidth - 2 * intervel;
        CGFloat title_h = (65/568.0) * kDeviceHeight;
        CGFloat button_w = (kDeviceWidth - 3 * intervel) * 0.5;
        
        self.titleImageView.frame = CGRectMake(intervel, title_y, title_w, title_h);
        
        CGFloat otButton_y = CGRectGetMaxY(self.titleImageView.frame) + intervel;
        self.firstButton.frame = CGRectMake(intervel, otButton_y, button_w, button_w);
        
        CGFloat tfButton_x = CGRectGetMaxX(self.firstButton.frame) + intervel;
        self.secondButton.frame = CGRectMake(tfButton_x, otButton_y, button_w, button_w);
        
        CGFloat tfButton_y = CGRectGetMaxY(self.firstButton.frame) + intervel;
        self.thirdButton.frame = CGRectMake(intervel, tfButton_y, button_w, button_w);
        self.fourthButton.frame = CGRectMake(tfButton_x, tfButton_y, button_w, button_w);
        
        CGFloat fbButton_y = CGRectGetMaxY(self.thirdButton.frame) + intervel;
        
        self.feedBackButton.frame = CGRectMake(intervel, fbButton_y, title_w, title_h);
        if (kDeviceHeight == 568) {
            self.feedBackButton.frame = CGRectMake(intervel, fbButton_y, title_w, 47);
        }
        
    }
}

/** 重写导航栏 */
- (void)initNavigationBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSShadowAttributeName : [[NSShadow alloc] init],
                                NSFontAttributeName : [UIFont systemFontOfSize:19]
                                };
    [navBar setTitleTextAttributes:textAttrs];
    navBar.barTintColor = XMColor(89, 122, 155);//背景色
    navBar.tintColor = [UIColor whiteColor];//item颜色
}

/** 其他反馈 */
- (IBAction)feedBackButton:(UIButton *)sender {
    
    XMUserResponseViewController *userResponseViewController = [[XMUserResponseViewController alloc] init];
    [self.navigationController pushViewController:userResponseViewController animated:YES];
    
    
    
}

/**
 *  选择更新后的心情
 */
- (IBAction)buttonClickedToChooseUserMood:(UIButton *)sender {
    
    NSString *barTitle = @"您更新后的感觉？";
    
    [self ShowSingleBarWithTitle:barTitle content:self.moodArray inputType:@"1"];
    
}

/**
 *  选择最有爱的更新
 */
- (IBAction)buttonClickedToChooseGoodIdea:(UIButton *)sender {
    
    NSString *barTitle = @"选择最有爱的更新!";
    
    [self ShowSingleBarWithTitle:barTitle content:self.nowArray inputType:@"2"];
    
}

/**
 *  选择最不给力的更新
 */
- (IBAction)buttonClickedToChooseBadIdea:(UIButton *)sender {
    
    NSString *barTitle = @"选择最期待的更新!";
    
    [self ShowSingleBarWithTitle:barTitle content:self.nowArray inputType:@"3"];
    
}

/**
 *  选择最期待的更新
 */
- (IBAction)buttonClickedToChooseHopeIdea:(UIButton *)sender {
    
    NSString *barTitle = @"选择最期待的更新!";
    
    [self ShowSingleBarWithTitle:barTitle content:self.hopeArray inputType:@"4"];
    
}

- (void)ShowSingleBarWithTitle:(NSString *)title content:(NSArray *)content inputType:(NSString *)input
{
    float with = self.view.frame.size.width * 0.7;
    
    float height = 350;
    
    JHSingleBar *singleBar = [JHSingleBar singleBarWithArray:content title:title frame:CGRectMake(0, 0, with, height)];
    singleBar.inputNumber = input;
    singleBar.center = self.view.center;
    self.singleBar = singleBar;
    singleBar.delegate = self;
    [self showCoderWithView:singleBar];
    
}

#pragma mark - --------------------代理方法方法入口--------------------
- (void)singleBar:(JHSingleBar *)singleBar didClickedButton:(UIButton *)button
{
    if ([UserDefaults objectForKey:@"userid"] && [UserDefaults objectForKey:@"password"]) {
        
        NSDictionary *param = @{@"userid" : [UserDefaults objectForKey:@"userid"],
                                @"password" : [UserDefaults objectForKey:@"password"],
                                @"apptype" : @"1",
                                @"clienttype" : @"2",
                                @"appupdatelog_id" : [NSString stringWithFormat:@"%ld", (long)button.tag],
                                @"type" : singleBar.inputNumber,
                                @"version" : AppVersion
                                };
        
        [self HandInFourPageForUserChooseInfoWithParams:param];
        
    }else{
        
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未登录，现在登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert1.tag = 101;
        [alert1 show];
        
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        
        [self hidenSingleBarCover];
        
        XMLoginViewController *loginViewController = [[XMLoginViewController alloc] init];
        
        [self.navigationController pushViewController:loginViewController animated:YES];
        
    }
}

#pragma mark - --------------------网络请求入口--------------------
/** 请求四格体验数据 */
- (void)requestDataForFourPage
{
    NSDictionary *param = @{@"apptype" : @"1",
                            @"clienttype" : @"2",
                            @"version" : AppVersion
                            };
    XMLog(@"---------请求四格体验数据参数：%@", param);
    
    [[XMDealTool sharedXMDealTool] requestFourPageInfoWithParams:param Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            self.moodArray = [NSArray arrayWithArray:deal[@"mood"]];
            self.nowArray = [NSArray arrayWithArray:deal[@"nowupdate"]];
            self.hopeArray = [NSArray arrayWithArray:deal[@"nextupdate"]];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }];
    
}

/** 提交四格体验数据 */
- (void)HandInFourPageForUserChooseInfoWithParams:(NSDictionary *)params
{
    
    XMLog(@"------提交四格体验数据参数:%@",params);
    
    [[XMDealTool sharedXMDealTool] handInFourPageInfoWithParams:params Success:^(NSDictionary *deal) {
        
        if ([deal[@"status"] isEqual: @1]) {
            
            XMLog(@"-----------饼图参数：%@", deal);
            [self hidenSingleBarCover];
            
            if (deal[@"message"]) {
                
                [MBProgressHUD showSuccess:deal[@"message"]];
                
            }else{
                
                [MBProgressHUD showError:@"您已经提交过！"];
                
            }
            
            
            // 显示饼状图
            float with = self.view.frame.size.width * 0.7;
            
            float height = 350;
            
            if (kDeviceHeight > 570) {
                
                height = 400;
            }
            
            CGRect pie_frame = CGRectMake(0, 0, with, height);
            NSString *title = @"看看其他人选了什么";
            JHPieChartBar *pieChartBar = [JHPieChartBar pieChartBarWithArray:deal[@"datalist"] title:title frame:pie_frame];
            pieChartBar.layer.masksToBounds = YES;
            pieChartBar.layer.cornerRadius = 3;
            self.pieChartBar = pieChartBar;
            pieChartBar.center = self.view.center;
            [self showPieBar];
            
        }else{
            
            if (deal[@"message"]) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:deal[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }
        
    }];
}

#pragma mark - --------------------其他方法入口--------------------
- (void)showPieBar
{
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = self.view.window.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(hidenPieCover) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:cover];
    self.pieCover = cover;
    
    
    // 2.添加图片
    [self.view.window addSubview:self.pieChartBar];
    [self.pieChartBar setHidden:YES];
    
    
    // 4.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        
        // 4.1.阴影慢慢显示出来
        cover.alpha = 0.5;
        
        // 4.2.显示图片
        [self.pieChartBar setHidden:NO];
    }];
    
}

- (void)hidenPieCover
{
    
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        self.pieChartBar.hidden = YES;
        // 阴影慢慢消失
        self.pieCover.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画执行完毕后会自动调用这个block内部的代码
        // 动画执行完毕后,移除遮盖(从内存中移除)
        [self.pieCover removeFromSuperview];
        [self.pieChartBar removeFromSuperview];
        self.pieCover = nil;
        self.pieChartBar = nil;
    }];
}

- (void)showCoderWithView:(UIView *)view
{
    // 1.添加阴影
    UIButton *cover = [[UIButton alloc] init];
    cover.frame = self.view.window.bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.0;
    [cover addTarget:self action:@selector(hidenSingleBarCover) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:cover];
    self.cover = cover;
    
    // 2.添加图片
    [self.view.window addSubview:view];
    [view setHidden:YES];
    
    
    // 4.执行动画
    [UIView animateWithDuration:0.25 animations:^{
        
        // 4.1.阴影慢慢显示出来
        cover.alpha = 0.5;
        
        // 4.2.显示图片
        [view setHidden:NO];
    }];
}

- (void)hidenSingleBarCover
{
    
    // 执行动画
    [UIView animateWithDuration:0.25 animations:^{
        // 存放需要执行动画的代码
        self.singleBar.hidden = YES;
        // 阴影慢慢消失
        self.cover.alpha = 0.0;
    } completion:^(BOOL finished) {
        // 动画执行完毕后会自动调用这个block内部的代码
        // 动画执行完毕后,移除遮盖(从内存中移除)
        [self.cover removeFromSuperview];
        [self.singleBar removeFromSuperview];
        self.cover = nil;
        self.singleBar = nil;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.cover) {
        [self hidenSingleBarCover];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
