//
//  JHCheckBar.m
//  XSM_XS
//
//  Created by Andy on 14-12-8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHCheckBar.h"
#import "JHChooseButton.h"
#import "XMCommon.h"
@interface JHCheckBar()<UIScrollViewDelegate>

//@property(nonatomic, strong)NSMutableArray *chooseButtons;

@property(nonatomic, strong)UIButton *okButton;
@property(nonatomic, strong)UIButton *selectButton;
@end

@implementation JHCheckBar


+ (instancetype)checkBarWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame andButtonType:(kButtonType)buttonType
{
    return [[JHCheckBar alloc] initWithArray:array andTitle:barTitle andFrame:frame andButtonType:buttonType];
}

- (instancetype)initWithArray:(NSArray *)array andTitle:(NSString *)barTitle andFrame:(CGRect)frame andButtonType:(kButtonType)buttonType
{
    self = [[JHCheckBar alloc] init];
    self.buttonStyle = buttonType;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setFrame:frame];
    
    // 添加背景图片
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    [backgroundImageView setFrame:self.bounds];
    [backgroundImageView setImage:[UIImage imageNamed:@"dialoguebox"]];
    [self addSubview:backgroundImageView];
    
    // 添加关闭按钮
    UIButton *closeButton = [self addbuttonWithNumalImage:@"button_close" highImage:@"" andAction:@selector(buttonClickedToClose:)];
    [closeButton setFrame:CGRectMake(12, 12, 15, 15)];
    [self addSubview:closeButton];
    
    // 添加标题
    UILabel *barTitleLabel = [self addLabelWithTitle:barTitle];
    CGFloat title_x = CGRectGetMaxX(closeButton.frame);
    CGFloat title_w = self.frame.size.width - 2 * title_x;
    [barTitleLabel setFrame:CGRectMake(title_x, 4, title_w, 30)];
    [self addSubview:barTitleLabel];
    
    // 确定按钮
    CGFloat ok_x = CGRectGetMaxX(barTitleLabel.frame);
    UIButton *okButton = [self addbuttonWithNumalImage:@"icon_chooce" highImage:@"" andAction:@selector(buttonClickedToOk:)];
    self.okButton = okButton;
    [okButton setFrame:CGRectMake(ok_x, 12, 15, 15)];
    [self addSubview:okButton];
    
    // 添加分割线
    UIView *coder = [[UIView alloc] init];
    CGFloat coder_y = CGRectGetMaxY(barTitleLabel.frame);
    [coder setFrame:CGRectMake(4, coder_y, self.frame.size.width - 8, 1)];
    [coder setBackgroundColor:kBorderColor];
    [self addSubview:coder];
    
    // 添加内容
    CGFloat scrollView_y = CGRectGetMaxY(coder.frame) + 1;
    UIScrollView *scrollView = [self addScrollViewWithArray:array andFrame:CGRectMake(15, scrollView_y, self.frame.size.width - 30, self.frame.size.height - scrollView_y -10)];
    
    [self addSubview:scrollView];

    return self;
}

- (UIScrollView *)addScrollViewWithArray:(NSArray *)array andFrame:(CGRect)frame
{
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setFrame:frame];
    scrollView.minimumZoomScale = 1;
    scrollView.maximumZoomScale = 2.5;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    UIView *chooseBar = [self chooseBarWithArray:array andFrame:CGRectMake(0, 0, scrollView.frame.size.width, 23 * array.count + 10)];
    [scrollView setContentSize:chooseBar.frame.size];
    [scrollView addSubview:chooseBar];
    return scrollView;
}



- (UIView *)chooseBarWithArray:(NSArray *)array andFrame:(CGRect)frame
{
    UIView *chooseBar = [[UIView alloc] init];
    [chooseBar setFrame:frame];
    
    CGFloat button_w = frame.size.width - 10;
    CGFloat button_h = 23;
    CGFloat button_x = 10;
    CGFloat intervel = 10;
    
    for (int index = 0; index < array.count; ++index) {
        
        JHChooseButton *button = [JHChooseButton buttonWithType:UIButtonTypeCustom];
        
        
        CGFloat button_y = button_h *index + intervel;
        [button setFrame:CGRectMake(button_x, button_y, button_w, button_h)];
        
        [button setImage:[UIImage imageNamed:@"button_notselected"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateSelected];
        
        NSString *button_title;
        
        if ([array[index] isKindOfClass:[NSString class]]) {
            
            button_title = array[index];
            button.tag = index + 1;
            
        }else{
            
            NSDictionary *dict = array[index];
            button_title = dict[@"typename"];
            button.tag = [dict[@"id"] intValue];
          
        }
        
        
        [button setTitle:button_title forState:UIControlStateNormal];
        [button setTitle:button_title forState:UIControlStateSelected];
        [button setTitleColor:XMButtonBg forState:UIControlStateNormal];
        [button setTitleColor:XMButtonBg forState:UIControlStateSelected];
        
        [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [button addTarget:self action:@selector(buttonClickedToChooseInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [chooseBar addSubview:button];
        
        NSDictionary *dict = array[index];
        if ([dict[@"checked"] isEqualToString:@"1"]) {
            [self buttonClickedToChooseInfo:button];
        }
        
    }
    
    return chooseBar;
}


- (UILabel *)addLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:XMButtonBg];
    
    return label;
}

- (UIButton *)addbuttonWithNumalImage:(NSString *)numalImage highImage:(NSString *)highImage andAction:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:numalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClickedToClose:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(checkBar:didClickCloseButton:)]) {
        
        [self.delegate checkBar:self didClickCloseButton:button];
        
    }
}

- (void)buttonClickedToOk:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(checkBar:didClickOkButton:)]) {
        
        [self.delegate checkBar:self didClickOkButton:button];
        
    }
}

- (void)buttonClickedToChooseInfo:(UIButton *)button
{
    if (self.buttonStyle == kSingleButton) { // 单选按钮
        
        self.selectButton.selected = NO;
        button.selected = YES;
        self.selectButton = button;
        if ([self.delegate respondsToSelector:@selector(checkBar:didClickSingleChooseButton:)]) {
            [self.delegate checkBar:self didClickSingleChooseButton:button];
        }
        
        
    }else{  // 复选按钮
        
        button.selected = !button.selected;
        if ([self.delegate respondsToSelector:@selector(checkBar:didClickCheckChooseButton:)]) {
            [self.delegate checkBar:self didClickCheckChooseButton:button];
        }
        
    }
    
    
    
}

- (void)layoutSubviews
{
    if (self.buttonStyle == kSingleButton) {
        self.okButton.hidden = YES;
    }
}

@end
