//
//  QHCustomButton.m
//  Demo
//
//  Created by Apple on 15/1/15.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import "QHCustomButton.h"
#import "UIColor+XM.h"
@interface QHCustomButton ()
{
    NSArray *_array;
}
@property (nonatomic, assign) kQHButtonStyle style;

@end

@implementation QHCustomButton

- (id)initWithStyle:(kQHButtonStyle)style
{
    self = [[QHCustomButton alloc] init];
    if (self) {
        self.style = style;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _array = @[@[@"修三星",@"home_icon_03"],
                   @[@"修华为",@"home_icon_05"],
                   @[@"修联想",@"home_icon_07"],
                   @[@"修魅族",@"home_icon_09"],
                   @[@"修苹果",@"home_icon_16"],
                   @[@"修小米",@"home_icon_19"],
                   @[@"修微软/诺基亚",@"1234_03"],
                   @[@"修中兴",@"home_icon_27"],
                   @[@"修HTC",@"home_icon_31"],
                   @[@"其他手机维修",@"home_icon_32"],
                   @[@"修锁",@"home_icon_36"],
                   @[@"手机回收",@"home_icon_39"],
                   ];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    for (int i=0; i<_array.count; i++) {
        if (title == _array[i][0]) {
            [self setImage:[UIImage imageNamed:_array[i][1]] forState:UIControlStateNormal];
        }
    }
    
    if (_style == QHButtonStyleSmaleImage) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }else if (_style == QHButtonStyleDefault){
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        if ([title isEqualToString:@"修小米"]) {
            [self setTitleColor:[UIColor colorWithHexString:@"ef7e00"] forState:UIControlStateNormal];
        }else{
            [self setTitleColor:[UIColor colorWithHexString:@"444444"] forState:UIControlStateNormal];
        }
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    if (self.style == QHButtonStyleDefault) {
        return CGRectMake(30, 10, 32, 32);
    }else if (self.style == QHButtonStyleBigImage){
        return CGRectMake(0, 20, contentRect.size.width, 43);
    }else{
        return CGRectMake(0, 0, 50, 50);
    }
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if (self.style == QHButtonStyleDefault) {
        return CGRectMake(64, 0, contentRect.size.width-64, contentRect.size.height);
    }else if (self.style == QHButtonStyleBigImage){
        return CGRectMake(0, 78, contentRect.size.width, 14);
    }else{
        return CGRectMake(0, 56, contentRect.size.width, 11);
    }
}

@end
