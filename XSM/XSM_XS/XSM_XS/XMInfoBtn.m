//
//  XMInfoBtn.m
//  XiuShemMa
//
//  Created by Apple on 14/10/23.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMInfoBtn.h"
#import "XMCommon.h"
#import "UIViewExt.h"
@implementation XMInfoBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    }
    return self;
}

//- (void)setHighlighted:(BOOL)highlighted
//{}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat w = self.width/3.0;
    CGFloat x = self.width/2.0-w/2.0;
    CGFloat y = self.height*0.6-w;
    return CGRectMake(x, y, w, w);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = self.height*0.6;
    return CGRectMake(0, y, self.width, self.height/6);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // 1.获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 2.设置
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, kBorderColor.CGColor);
    
    // 3.画线
    CGFloat endX = rect.size.width;
    CGFloat endY = rect.size.height;
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, endX, 0);
    CGContextAddLineToPoint(ctx, endX, endY);
    CGContextAddLineToPoint(ctx, 0, endY);
    CGContextClosePath(ctx);//闭合
    
    // 4.渲染
    CGContextStrokePath(ctx);
}

@end
