//
//  XMInfoBtn.m
//  XiuShemMa
//
//  Created by Apple on 14/10/23.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMInfoBtn.h"

@implementation XMInfoBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
        
        self.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(contentRect.size.width/2-60/2, self.height*0.6-self.height/3, 60, self.height/3);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, self.height*2/3, self.width, self.height/6);
}

@end
