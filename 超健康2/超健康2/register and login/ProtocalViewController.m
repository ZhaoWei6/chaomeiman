//
//  ProtocalViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-11.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "ProtocalViewController.h"

@interface ProtocalViewController ()

@end

@implementation ProtocalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏背景"] forBarMetrics:UIBarMetricsDefault];
    }
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundColor"]];

    [self addLeftButtonReturn:@selector(dismiss)];
    
    UIWebView *web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-64)];
    [self.view addSubview:web];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"协议" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth/2, 40)];
    label.textColor=[UIColor whiteColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:25];
    label.text=@"用户协议";
    self.navigationItem.titleView=label;
//
//    UITextView *text=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, kDeviceWidth-10, kDeviceHeight/2)];
//    text.text=@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet lacus accumsan et viverra justo commodo. Proin sodales pulvinar tempor. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam fermentum, nulla luctus pharetra vulputate, felis tellus mollis orci, sed rhoncus sapien nunc eget odio.";
//    [self.view addSubview:text];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
