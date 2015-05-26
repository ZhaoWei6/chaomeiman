//
//  JHSingleBar.m
//  XSM_XS
//
//  Created by Andy on 15/1/6.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import "JHSingleBar.h"
#import "XMCommon.h"

@interface JHSingleBar()

@property(nonatomic, strong)UIImageView *backImageView;

@end

@implementation JHSingleBar

+ (instancetype)singleBarWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame
{
    return [[JHSingleBar alloc] initWithArray:array title:title frame:frame];
}

- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame
{
    self = [[JHSingleBar alloc] init];
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // 添加背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [backgroundImageView setFrame:self.bounds];
    self.backImageView = backgroundImageView;
    [backgroundImageView setImage:[UIImage imageNamed:@"four_mood"]];
    [self addSubview:backgroundImageView];
    
    // 添加标题
    UILabel *barTitleLabel = [self addLabelWithTitle:title];
    CGFloat title_x = frame.size.width*0.20;
    CGFloat title_w = self.frame.size.width - title_x;
    [barTitleLabel setFrame:CGRectMake(title_x, frame.size.height * 0.20, title_w, 25)];
    [self addSubview:barTitleLabel];

    // 内容
    CGFloat chooseBar_y = CGRectGetMaxY(barTitleLabel.frame) + 10;
    UIView *chooseBar = [self chooseBarWithArray:array andFrame:CGRectMake(15, chooseBar_y, frame.size.width, frame.size.height - chooseBar_y - 15)];
    [self addSubview:chooseBar];

    
    return self;
}

- (void)setInputNumber:(NSString *)inputNumber
{
    _inputNumber = inputNumber;
    
    NSArray *backarray = @[@"four_mood", @"four_good", @"four_bad", @"four_hope"];
    
    [self.backImageView setImage:[UIImage imageNamed:backarray[[inputNumber intValue] - 1]]];
    
}

- (UIView *)chooseBarWithArray:(NSArray *)array andFrame:(CGRect)frame
{
    UIView *chooseBar = [[UIView alloc] init];
    [chooseBar setFrame:frame];
    
    CGFloat button_w = frame.size.width * 0.6;
    CGFloat button_h = 30;
    CGFloat button_x = frame.size.width*0.21;
    CGFloat intervel = 13;
    
    for (int index = 0; index < array.count; ++index) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat button_y = (button_h + intervel) * index;
        [button setFrame:CGRectMake(button_x, button_y, button_w, button_h)];
        
        NSString *button_title;
        
        if ([array[index] isKindOfClass:[NSString class]]) {
            
            button_title = array[index];
            button.tag = index + 1;
            
        }else{
            
            NSDictionary *dict = array[index];
            button_title = dict[@"appupdatelog"];
            button.tag = [dict[@"id"] integerValue];
            
        }
        
        [button setTitle:button_title forState:UIControlStateNormal];
        [button setTitle:button_title forState:UIControlStateHighlighted];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 3;
        
        [button addTarget:self action:@selector(buttonClickedToChooseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [chooseBar addSubview:button];
        
    }
    
    return chooseBar;
}

- (void)buttonClickedToChooseButton:(UIButton *)button
{
//    self.selectButton.selected = NO;
//    button.selected = YES;
//    self.selectButton = button;
    
    if ([self.delegate respondsToSelector:@selector(singleBar:didClickedButton:)]) {
        [self.delegate singleBar:self didClickedButton:button];
    }
    
}

- (UILabel *)addLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:19]];
    [label setTextColor:XMButtonBg];
    
    return label;
}

@end
