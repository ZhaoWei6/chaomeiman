//
//  WBProgressPieView.h
//  WBProgressPieDemo
//
//  Created by luweibai on 14/12/15.
//  Copyright (c) 2014年 Weibai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBProgressPieView : UIView


+ (instancetype)progressPieViewWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor: (UIColor *)innerColor;

- (instancetype)initWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor: (UIColor *)innerColor;

- (void)resetDataSetWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor: (UIColor *)innerColor;

@end
