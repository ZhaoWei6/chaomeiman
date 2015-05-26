//
//  QHCustomButton.h
//  Demo
//
//  Created by Apple on 15/1/15.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum QHButtonStyle
{
    QHButtonStyleDefault    = 0,   //默认   矩形按钮，左图右字
    QHButtonStyleSmaleImage = 1,   //大图
    QHButtonStyleBigImage   = 2    //小图
}kQHButtonStyle;

@interface QHCustomButton : UIButton

- (id)initWithStyle:(kQHButtonStyle)style;

@end
