//
//  XMItem.m
//  XiuShemMa
//
//  Created by Apple on 14/10/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMItem.h"

@implementation XMItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
        [self setTitleColor:XMButtonBg forState:UIControlStateDisabled];
        
        self.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.width/2 - self.height/3, 5, self.height*2/3, self.height*2/3-10);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.height*2/3-2, self.width, self.height/3-5);
}

@end
