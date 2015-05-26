//
//  XMDealBottomMenu.h
//  XiuShemMa
//
//  Created by Apple on 14-10-10.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMDealBottomMenu : UIView
{
    UIScrollView *_scrollView;
    UIButton *_selectedItem;
}
@property (nonatomic, copy) void (^hideBlock)();//取消选中的按钮,将记录变量置空,以及释放对应的区域、菜单   »»»»»»»»»»»在hide方法中调用

// 通过动画显示出来»»遮罩+_contentView
- (void)show;//◊在没有按钮被选中时调用◊没有父控件时调用◊
// 通过动画隐藏»»遮罩+_contentView
- (void)hide;

- (void)itemClick:(UIButton *)btn;

@end
