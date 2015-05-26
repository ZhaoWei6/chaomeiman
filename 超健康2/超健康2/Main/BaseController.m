//
//  BaseController.m
//  Chaomeiman 专家端
//
//  Created by imac on 15-1-24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//点击左键
-(void)addLeftButtonReturn: (SEL)buttonClicked{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"goBack.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 35, 35)];
    [button addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=bar;
}

//点击左键
-(void)addLeftButtonReturn:(NSString *)title with:(SEL)buttonClicked{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 35, 35)];
    [button addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=bar;
}

//点击右键(带字)
-(void)addRightButtonReturn: (NSString *)title with:(SEL)buttonClicked{
   UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
   [rightButton setFont:[UIFont systemFontOfSize:15]];
   [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   [rightButton setTitle:title forState:UIControlStateNormal];
   [rightButton setFrame:CGRectMake(0, 0, 80, 40)];
   [rightButton addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
   UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
   self.navigationItem.rightBarButtonItem=rightBar;
}

//点击右键(带照片)
-(void)addRightImageReturn:(NSString *)imageName with:(SEL)buttonClicked{
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton setFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBar;
}

//点击右键(带照片,带frame大小)
-(void)addRightImageFrameReturn:(NSString *)imageName rect:(CGRect)rect1 with:(SEL)buttonClicked{
    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightButton setFrame:rect1];
    [rightButton addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightBar;
}

//增加在试图上得按钮
-(void)addViewInButton:(NSString *)title rect:(CGRect)rect1 with:(SEL)buttonClicked{
    UIButton *buttonName=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonName.frame=rect1;
    buttonName.layer.borderWidth=0.5f;
    buttonName.layer.borderColor=[[UIColor blackColor]CGColor];
    [buttonName setTitle:title forState:UIControlStateNormal];
    [buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonName setFont:[UIFont systemFontOfSize:12]];
    //[buttonName setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [buttonName addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonName];
}

//增加在视图上的按钮
-(void)addViewInButtonInHigh:(NSString *)imageName HighLight:(NSString *)highImage rect:(CGRect)rect1 with:(SEL)buttonClicked{
    UIButton *buttonName=[UIButton buttonWithType:UIButtonTypeCustom];
    buttonName.frame=rect1;
    [buttonName setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [buttonName setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [buttonName addTarget:self action:buttonClicked forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonName];
}

@end
