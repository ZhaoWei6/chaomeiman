//
//  XMTabBar.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMTabBar;
@protocol XMTabBarDelegate <NSObject>

@optional
/**
 *  参数
 *
 *  @param tabBar 分栏
 *  @param from   上一次点击的Item的tag
 *  @param to     本次点击的Item的tag
 */
- (void)tabBar:(XMTabBar *)tabBar didSelectItemFrom:(NSUInteger )from to:(NSUInteger )to;

@end
@interface XMTabBar : UIView

//设置分栏项的默认背景图和选中背景图
- (void)addTabBarItemWithTitle:(NSString *)title icon:(NSString *)icon selectIcon:(NSString *)selectIcon;
//
- (void)addTabBarItem:(NSString *)title;

@property (weak,nonatomic) id<XMTabBarDelegate> delegate;

@end
