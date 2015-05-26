//
//  JHPieChartBar.h
//  XSM_XS
//
//  Created by Andy on 15/1/7.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHPieChartBar;

@protocol JHPieChartBarDelegate <NSObject>

@optional
/**
 *  选定按钮的代理
 *
 *  @param singleBar 单选工具栏
 *  @param button    选中的按钮
 */
- (void)pieChartBar:(JHPieChartBar *)pieChartBar didClickedButton:(UIButton *)button;

@end

@interface JHPieChartBar : UIView

@property(nonatomic, weak) id <JHPieChartBarDelegate> delegate;
/**
 *  快速饼状图
 */
+ (instancetype)pieChartBarWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame;
- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame;
@end
