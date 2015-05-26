//
//  XMProblemController.m
//  XiuShenMa
//
//  Created by Apple on 14/11/4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMProblemController.h"

@interface XMProblemController ()
{
    UIWebView *myWebView;
}
@end

@implementation XMProblemController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"常见问题";
        self.view.backgroundColor=[UIColor whiteColor];    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kDeviceWidth, kDeviceHeight-64)];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Q&A" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [self.view addSubview:myWebView];
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
