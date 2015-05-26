//
//  XMDealBottomMenu.m
//  XiuShemMa
//
//  Created by Apple on 14-10-10.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMDealBottomMenu.h"
#import "XMCover.h"

#import "XMMetaDataTool.h"
@interface XMDealBottomMenu()
{
    XMCover *_cover; // 遮盖
    
    UIView *_contentView;
}
@end

@implementation XMDealBottomMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // 1.添加蒙板（遮盖）
        _cover = [XMCover coverWithTarget:self action:@selector(hide)];
        _cover.frame = self.bounds;
        [self addSubview:_cover];
        
        // 2.内容view
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, 0, self.frame.size.width, 200);
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_contentView];
        
        // 3.添加UIScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        scrollView.frame = CGRectMake(0, 0, self.frame.size.width, 200);
        
        scrollView.backgroundColor = [UIColor whiteColor];
        [_contentView addSubview:scrollView];
        _scrollView = scrollView;
    }
    return self;
}

#pragma mark 显示
- (void)show
{
    _contentView.alpha = 0;
    _cover.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _contentView.alpha = 1;
        [_cover reset];
    }];
}

- (void)hide
{
    if (_hideBlock) {
        _hideBlock();
    }
    [UIView animateWithDuration:0.3 animations:^{
        _cover.alpha = 0;
    } completion:^(BOOL finished) {
        // 从父控件中移除
        [self removeFromSuperview];
        _contentView.alpha  = 1;
        [_cover reset];
    }];
}

- (void)itemClick:(UIButton *)btn
{
    if (btn.tag < 1000) {
        XMLog(@"点击的是机型");
        [XMMetaDataTool sharedXMMetaDataTool].currentCategoryTitle = btn.titleLabel.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryChangeNote object:nil];
    }else if (btn.tag >= 2000){
        XMLog(@"点击的是排序");
        [XMMetaDataTool sharedXMMetaDataTool].currentOrderTitle = btn.titleLabel.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderChangeNote object:nil];
        
    }
    XMLog(@"click----%@",btn.titleLabel.text);
}

@end
