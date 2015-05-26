//
//  TGCover.m
//  团购
//
//  Created by app35 on 14-7-28.
//  Copyright (c) 2014年 sk. All rights reserved.
//

#import "TGCover.h"
#define kAlpha 0.6
@implementation TGCover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.背景色
        self.backgroundColor = [UIColor blackColor];
        
        // 2.自动伸缩
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // 3.透明度
        self.alpha = kAlpha;
    }
    return self;
}
- (void)reset
{
    self.alpha = kAlpha;
}

+ (id)cover
{
    return [[self alloc] init];
}

+ (id)coverWithTarget:(id)target action:(SEL)action
{
    TGCover *cover = [self cover];
    
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
    
    return cover;
}

@end
