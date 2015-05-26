//
//  TGDealTopMenuItem.m
//  团购
//
//  Created by app04 on 14-7-24.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMDealTopMenuItem.h"

#define kTitleScale 0.8

@implementation XMDealTopMenuItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kRepairTextFont;
        
        // 2.设置箭头
        [self setImage:[UIImage imageNamed:@"ic_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"ic_arrow_up"] forState:UIControlStateSelected];
        self.imageView.contentMode = UIViewContentModeLeft;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    [self setTitle:title forState:UIControlStateNormal];
}

//  重新设置按钮标题和箭头位置
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.x -= 5;
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect.origin.x += (self.width*2/3 + 8);
    return contentRect;
}

//  取消高亮状态
- (void)setHighlighted:(BOOL)highlighted
{}

@end
