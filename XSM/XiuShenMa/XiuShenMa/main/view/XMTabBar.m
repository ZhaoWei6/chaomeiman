//
//  XMTabBar.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMTabBar.h"
#import "XMItem.h"
#import "UIImage+XM.h"
@interface XMTabBar ()
{
    UIButton *_selectItem;
    UIView *_contentView;
}
@end

@implementation XMTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 添加按钮
//
- (void)addTabBarItemWithTitle:(NSString *)title icon:(NSString *)icon selectIcon:(NSString *)selectIcon
{
    XMItem *button = [[XMItem alloc] initWithFrame:CGRectZero];
    
//    button.imageView.contentMode = UIViewContentModeCenter;
    [button setTitle:title forState:UIControlStateNormal];
    //
    [button setImage:[UIImage resizedImage:icon] forState:UIControlStateNormal];
    //
    [button setImage:[UIImage resizedImage:selectIcon] forState:UIControlStateDisabled];
    
    [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    button.tag = self.subviews.count;
    
    [self addSubview:button];
    [self adjustItemFrames];
    
    if (self.subviews.count == 1) {
        [self itemClick:button];
    }
}
//
- (void)addTabBarItem:(NSString *)title
{
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    item.backgroundColor = [UIColor grayColor];
    
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:item];
    
    [self adjustItemFrames];
    
    item.tag = self.subviews.count - 1;
    if (self.subviews.count == 1) {
        [self itemClick:item];
    }
}
#pragma mark 重新调整所有按钮的frame
- (void)adjustItemFrames
{
    NSInteger btnCount = self.subviews.count;
    for (int i = 0; i < btnCount; i++) {
        UIButton *item = self.subviews[i];
        
        // 设置frame
        CGFloat buttonY = 0;
        CGFloat buttonW = (self.width - 2) / btnCount;
        CGFloat buttonX = i * (buttonW + 1);
        CGFloat buttonH = self.height;
        item.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

#pragma mark 监听按钮点击
- (void)itemClick:(UIButton *)item
{
    if (item == _selectItem) {
        return;
    }
    // 1.通知代理      控制分栏控制器根据按钮标签选择控制器
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectItemFrom:to:)]) {
        [_delegate tabBar:self didSelectItemFrom:_selectItem.tag to:item.tag];
    }
    
    // 2.切换按钮状态
//    _selectItem.backgroundColor = [UIColor grayColor];
//    item.backgroundColor = [UIColor blackColor];
    
    _selectItem.enabled = YES;
    item.enabled = NO;
    _selectItem = item;
}

@end




