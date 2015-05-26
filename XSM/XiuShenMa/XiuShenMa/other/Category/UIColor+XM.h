//
//  UIColor+XM.h
//  XiuShenMa
//
//  Created by Apple on 15/1/12.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XM)

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
