//
//  JHSingleBar.h
//  XSM_XS
//
//  Created by Andy on 15/1/6.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHSingleBar;

@protocol JHSingleBarDelegate <NSObject>

@optional

/**
 *  选定按钮的代理
 *
 *  @param singleBar 单选工具栏
 *  @param button    选中的按钮
 */
- (void)singleBar:(JHSingleBar *)singleBar didClickedButton:(UIButton *)button;

@end

@interface JHSingleBar : UIView

@property (nonatomic, strong) NSString *inputNumber;

@property(nonatomic, weak) id <JHSingleBarDelegate> delegate;

/**
 *  根据ID创建单选框
 *
 *  @param ID ID
 */
+ (instancetype)singleBarWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame;
- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame;

@end
