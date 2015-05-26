//
//  XMAboutController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAboutController.h"

@interface XMAboutController ()

@end

@implementation XMAboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"关于我们";
    [self initContentView];
}

-(void)initContentView
{
    self.view.backgroundColor = XMGlobalBg;
    
    UIImageView  *LogoView = [[UIImageView alloc]init];
    LogoView.image = [UIImage imageNamed:@"logo"];
    LogoView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:LogoView];
    
    UILabel  *label = [[UILabel alloc]init ];
    label.numberOfLines=0;
    
    label.textAlignment=NSTextAlignmentCenter;

    
    NSString *verSion = [NSString stringWithFormat:@"V%@",AppVersion];
    label.text=[NSString stringWithFormat:@"%@ \n北京修神马科技有限公司 \n版权所有",verSion];
    
    [self.view addSubview:label];
    
    LogoView.bounds = CGRectMake(0, 0, kDeviceWidth*(2/3.0f), kDeviceWidth*(2/3.0f));
    LogoView.center = CGPointMake(kDeviceWidth/2, (kDeviceHeight-64)/2.0f-40);
    
    label.frame = CGRectMake(LogoView.left, LogoView.bottom+15, LogoView.width, 65);
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
