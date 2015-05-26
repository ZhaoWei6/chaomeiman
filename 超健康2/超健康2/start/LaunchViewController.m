//
//  LaunchViewController.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "LaunchViewController.h"
#import "LoginViewController.h"
@interface LaunchViewController ()

{
    UIScrollView *_scrollView;
    int index;
}

@end

@implementation LaunchViewController

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
    [self loadImageView];
	// Do any additional setup after loading the view.
}
-(void)loadImageView{
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _scrollView.backgroundColor=[UIColor clearColor];
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.contentSize=CGSizeMake(kDeviceWidth*4, 10);
    [self.view addSubview:_scrollView];
    float _x = 0;
    for (index = 0; index <4; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0+_x, 0, kDeviceWidth, kDeviceHeight)];
        NSString *imageName = [NSString stringWithFormat:@"%dzt.jpg", index+1];
        imageView.image = [UIImage imageNamed:imageName];
        imageView.tag=index;
        [_scrollView addSubview:imageView];
        _x += kDeviceWidth;
        if (index==3) {
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(select)];
            [imageView addGestureRecognizer:tap];
        }
    }
}

-(void)select{
    LoginViewController * app = [[LoginViewController alloc]init];
    self.view.window.rootViewController=app;
    [NSThread sleepForTimeInterval:0.5];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    for(UIView *view in _scrollView.subviews){
        [view removeFromSuperview];
    }
}

//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    if (_scrollView.contentOffset.x==kDeviceWidth*4) {
//        LoginViewController * app = [[LoginViewController alloc]init];
//        self.view.window.rootViewController=app;
//        return;
//    }
//}

@end
