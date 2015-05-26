//
//  XMGoodsView.h
//  XiuShemMa
//
//  Created by Apple on 14-10-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMGoodsViewTouchDelegate <NSObject>

- (void)touchImageViewWithImage:(UIImage *)image;

@end


@interface XMGoodsView : UIView

@property (nonatomic , assign) id<XMGoodsViewTouchDelegate>delegate;

//- (void)loadSubViewWithIcon:(NSString *)icon title:(NSString *)title newprice:(CGFloat)newprice  oldprice:(CGFloat)oldprice;
- (void)loadSubViewWithIcon:(NSString *)icon title:(NSString *)title price:(CGFloat)price oldprice:(CGFloat)oldprice;

@end
