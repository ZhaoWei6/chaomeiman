//
//  AboutUsViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-15.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController (){
    UIWebView *phoneCallWebView;
}

@end

@implementation AboutUsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"关于我们";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self addLeftButtonReturn:@selector(dismiss)];
    [self addRightImageFrameReturn:@"电话48-48.9.png" rect:CGRectMake(0, 0, 50, 40) with:@selector(rightDismiss)];
    
    self.title=@"关于我们";
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor=[UIColor whiteColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 30)];
    label.text=@"软件介绍：";
    label.numberOfLines=0;
    label.textColor=[UIColor blackColor];
    [self.view addSubview:label];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label.bottom, label.width, 1)];
    label1.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:169.0/255.0 blue:44.0/255.0 alpha:0.43];
    [self.view addSubview:label1];
    
    UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label1.bottom, label.width, 140)];
    label2.text=@"   关爱健康，享受健康是人类永恒的主题。超健康软件，目前主要是一个健康营养咨询的软件，有健康营养方面的知识、视频、资料等等。做到让老百姓切实体验到“健康随行，私人订制”的优质服务";
    label2.numberOfLines=0;
    label2.textColor=[UIColor blackColor];
    [self.view addSubview:label2];
    
    
    UILabel *label4=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label2.bottom+20, label.width, 30)];
    label4.text=@"超健康团队：";
    label4.numberOfLines=0;
    label4.textColor=[UIColor blackColor];
    [self.view addSubview:label4];
    
    UILabel *label5=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label4.bottom, label.width, 1)];
    label5.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:169.0/255.0 blue:44.0/255.0 alpha:0.43];
    [self.view addSubview:label5];
    
    UILabel *label6=[[UILabel alloc]initWithFrame:CGRectMake(label.left, label5.bottom, label.width, 80)];
    label6.text=@"   超健康团队充满着青春活力、奋发向上的精神，他们用真诚热情的心，为每一位超健康用户服务着。";
    label6.numberOfLines=0;
    label6.textColor=[UIColor blackColor];
    [self.view addSubview:label6];
}

-(void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightDismiss{
    MyLog(@"打电话");
    NSString *phoneNum = @"01061943511";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://01061943511"]];
}
@end
