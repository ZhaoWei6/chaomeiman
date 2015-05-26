//
//  JHNotHaveShopView.m
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHNotHaveShopView.h"

@interface JHNotHaveShopView()

@end

@implementation JHNotHaveShopView

+ (instancetype)notHaveShopView
{
    
    JHNotHaveShopView *notHaveShopView = [[[NSBundle mainBundle] loadNibNamed:@"JHNotHaveShopView" owner:nil options:nil] lastObject];
    return notHaveShopView;
    
}

- (IBAction)buttonClickedToSetupShop:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(notHaveShopView:didClicked:)]) {
        [self.delegate notHaveShopView:self didClicked:@"成功"];
    }
}

@end
