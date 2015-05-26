//
//  BaseController.h
//  Chaomeiman 专家端
//
//  Created by imac on 15-1-24.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseController : UIViewController

//导航栏左侧点击返回
-(void)addLeftButtonReturn: (SEL)buttonClicked;

//带“字”的返回
-(void)addLeftButtonReturn:(NSString *)title with:(SEL)buttonClicked;

//导航栏右侧带“字”点击进入
-(void)addRightButtonReturn: (NSString *)title with:(SEL)buttonClicked;

//点击右键(带照片)
-(void)addRightImageReturn:(NSString *)imageName with:(SEL)buttonClicked;

//点击右键(带照片,带frame大小)
-(void)addRightImageFrameReturn:(NSString *)imageName  rect:(CGRect)rect1 with:(SEL)buttonClicked;

//增加在视图上得按钮
-(void)addViewInButton:(NSString *)imageName rect:(CGRect)rect1 with:(SEL)buttonClicked;

//点击高亮显示
-(void)addViewInButtonInHigh:(NSString *)imageName HighLight:(NSString *)highImage rect:(CGRect)rect1 with:(SEL)buttonClicked;
@end
