//
//  JHSingleButton.m
//  数字图像
//
//  Created by 李江辉 on 14-12-2.
//  Copyright (c) 2014年 李江辉. All rights reserved.
//

#import "JHSingleButton.h"

@implementation JHSingleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

// 重写去掉高亮状态
- (void)setHighlighted:(BOOL)highlighted {}

// 内部图片的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width * 0.7;
    CGFloat imageH = 2;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = contentRect.size.height - 2;

    return CGRectMake(imageX, imageY, imageW, imageH);
}

// 内部文字的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
