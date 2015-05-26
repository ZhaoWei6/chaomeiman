//
//  JHNotHaveShopView.h
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHNotHaveShopView;

@protocol JHNotHaveShopViewDelegate <NSObject>

@optional
- (void)notHaveShopView:(JHNotHaveShopView *)notHaveShopView didClicked:(NSString *)tishi;

@end

@interface JHNotHaveShopView : UIView

@property(nonatomic, weak) id <JHNotHaveShopViewDelegate> delegate;
+ (instancetype)notHaveShopView;
@end
