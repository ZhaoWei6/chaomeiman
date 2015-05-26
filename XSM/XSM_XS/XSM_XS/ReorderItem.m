//
//  ReorderItem.m
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "ReorderItem.h"
#import "XMCommon.h"
#import "UIViewExt.h"
@implementation ReorderItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat h = self.height - 2;
    CGFloat w = self.width * 0.7;
    CGFloat x = (self.width - w)/2;
    return CGRectMake(x, h, w, 2);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat y = self.height * 0.1;
    CGFloat h = self.height * 0.8;
    CGFloat w = self.width;
    return CGRectMake(0, y, w, h);
}

@end
