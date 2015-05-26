//
//  QHCustomCell.m
//  Demo
//
//  Created by Apple on 15/1/14.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import "QHCustomCell.h"
#import "CycleScrollView.h"
#import "UIViewExt.h"
//#import "UIView+Shadow.h"
#import "UIColor+XM.h"
#import "QHCustomButton.h"
#import "XMBanner.h"

#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

@interface QHCustomCell ()<CycleScrollViewDelegate>

@property (nonatomic , retain) CycleScrollView *mainScorllView;

@end

@implementation QHCustomCell

- (id)initWithStyle:(kQHCustionCellStyle)style contentArray:(NSArray *)contentArray identifier:(NSString *)identifier
{
    self = [[QHCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (self) {
        switch (style) {
            case QHCustionCellStyleDefault:
                [self initDefaulWithArray:contentArray];
                break;
            case QHCustionCellStyleBunner:
                if (contentArray.count) {
                    [self initBunnerWithArray:contentArray];
                }
                break;
            case QHCustionCellStyleMain:
                [self initMainWithArray:contentArray];
                break;
            case QHCustionCellStyleHot:
                [self initHotWithArray:contentArray];
                break;
            case QHCustionCellStyleOther:
                [self initOtherWithArray:contentArray];
                break;
        }
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark QHCustionCellStyleBunner
- (void)initBunnerWithArray:(NSArray *)array
{
    CGRect frame = CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*5/18.0);
    
    // 设置轮播内容区图片
    NSMutableArray *viewsArray = [@[] mutableCopy];
    
    for (int i=0; i<array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        XMBanner *ban = array[i];
        XMLog(@"图片url------->%@",ban.banner);
        [imageView setImageWithURL:[NSURL URLWithString:ban.banner] placeholderImage:[UIImage imageNamed:@"banner_register"]];
        
        [imageView setClipsToBounds:YES];
        [viewsArray addObject:imageView];
    }
    
    XMLog(@"viewsArray----->%@",viewsArray);
    self.mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*5/18.0) animationDuration:3];
    
    self.mainScorllView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return viewsArray[pageIndex];
    };
    
    self.mainScorllView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
    
    self.mainScorllView.delegatee = self;
    
    [self.contentView addSubview:self.mainScorllView];
    
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = self.mainScorllView.frame.size.height;
    self.frame = cellFrame;
}
#pragma mark QHCustionCellStyleMain
- (void)initMainWithArray:(NSArray *)array;
{
    [self initTopView];
    for (int i=0; i<array.count; i++) {
        NSString *str = array[i];
        UIButton *button = [[QHCustomButton alloc] initWithStyle:QHButtonStyleSmaleImage];
        [button setTitle:str forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        /**  */
        [button setExclusiveTouch:YES];
    }
    [self adjuatButtonFrame:array];
}
- (void)adjuatButtonFrame:(NSArray *)array
{
    CGFloat l;
    
    if (array.count>4) {
        l = (CGFloat)(kDeviceWidth-50*4)/5;
    }else{
        l = (CGFloat)(kDeviceWidth-50*array.count)/(array.count+1);
    }
    for (UIButton *btn in self.contentView.subviews) {
        NSInteger i = btn.tag;
        if (i/4) {
            btn.frame = CGRectMake(l+(l+50)*(i%4), 19+76*(i/4), 50, 76);
        }else{
            btn.frame = CGRectMake(l+(l+50)*i, 19, 50, 76);
        }
    }
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = array.count>4 ?85*(array.count)/4+10 :95;
    self.frame = cellFrame;
}
#pragma mark QHCustionCellStyleHot
- (void)initHotWithArray:(NSArray *)array
{
    [self initTopView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 35)];
    label.font = [UIFont systemFontOfSize:15];
    [label setText:@"热门手机维修"];
    [self addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom-0.5, kDeviceWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:line];
    
    for (int i=0; i<array.count; i++) {
        NSString *str = array[i];
        QHCustomButton *button = [[QHCustomButton alloc] initWithStyle:QHButtonStyleBigImage];
        [button setTitle:str forState:UIControlStateNormal];
        if (i>=2) {
            button.frame = CGRectMake(kDeviceWidth/2*(i%2), label.bottom+i/2*110, kDeviceWidth/2, 110);
        }else{
            button.frame = CGRectMake(kDeviceWidth/2*i, label.bottom, kDeviceWidth/2, 110);
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        /**  */
        [button setExclusiveTouch:YES];
    }
    
    CGRect cellFrame = self.frame;
    if (array.count%2) {
        cellFrame.size.height = 45+(array.count)/2*110+110;
    }else{
        cellFrame.size.height = 45+(array.count)/2*110;
    }
    self.frame = cellFrame;
    
    UIView *lineCenter = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2, label.bottom+10, 0.5, self.height-label.height-30)];
    lineCenter.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:lineCenter];
}
#pragma mark QHCustionCellStyleDefault
- (void)initDefaulWithArray:(NSArray *)array
{
    [self initTopView];
    
    for (int i=0; i<array.count; i++) {
        NSString *str = array[i];
        QHCustomButton *button = [[QHCustomButton alloc] initWithStyle:QHButtonStyleDefault];
        [button setTitle:str forState:UIControlStateNormal];
        if (i>=2) {
            button.frame = CGRectMake(kDeviceWidth/2*(i%2), 10+i/2*52, kDeviceWidth/2, 52);
        }else{
            button.frame = CGRectMake(kDeviceWidth/2*i, 10, kDeviceWidth/2, 52);
        }
        
        if (i%2 && i>=2) {
            UIView *lineCenter_H = [[UIView alloc] initWithFrame:CGRectMake(10, 10+i/2*52, kDeviceWidth-20, 0.5)];
            lineCenter_H.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
            [self addSubview:lineCenter_H];
        }
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        /**  */
        [button setExclusiveTouch:YES];
    }
    
    CGRect cellFrame = self.frame;
    if (array.count%2) {
        cellFrame.size.height = 10+(array.count)/2*52+52;
    }else{
        cellFrame.size.height = 10+(array.count)/2*52;
    }
    self.frame = cellFrame;
    
    UIView *lineCenter_V = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2, 20, 0.5, self.height-30)];
    lineCenter_V.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:lineCenter_V];
}
#pragma mark QHCustionCellStyleOther
- (void)initOtherWithArray:(NSArray *)array
{
    [self initTopView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth-20, 35)];
    label.font = [UIFont systemFontOfSize:15];
    [label setText:@"其他维修服务"];
    [self addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom-0.5, kDeviceWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:line];
    
    for (int i=0; i<array.count; i++) {
        NSString *str = array[i];
        QHCustomButton *button = [[QHCustomButton alloc] initWithStyle:QHButtonStyleDefault];
        [button setTitle:str forState:UIControlStateNormal];
        if (i>=2) {
            button.frame = CGRectMake(kDeviceWidth/2*(i%2), label.bottom+i/2*52, kDeviceWidth/2, 52);
        }else{
            button.frame = CGRectMake(kDeviceWidth/2*i, label.bottom, kDeviceWidth/2, 52);
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        /**  */
        [button setExclusiveTouch:YES];
    }
    
    CGRect cellFrame = self.frame;
    if (array.count%2) {
        cellFrame.size.height = 45+(array.count)/2*52+52;
    }else{
        cellFrame.size.height = 45+(array.count)/2*52;
    }
    self.frame = cellFrame;
    
    UIView *lineCenter = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2, label.bottom+10, 0.5, self.height-label.height-30)];
    lineCenter.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
    [self addSubview:lineCenter];
}


#pragma mark -
- (void)initTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    topView.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
    [self addSubview:topView];
}
#pragma mark - CycleScrollViewDelegate
- (void)contentViewClick:(NSInteger)index
{
    NSLog(@"点击了%ld张图片",index);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickHomeHeadView" object:@{@"index":@(index)}];
}

#pragma mark - clickButton
- (void)clickButton:(UIButton *)sender
{
    NSString *str = sender.titleLabel.text;
    NSLog(@"点击了%@按钮",str);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickButton" object:@{@"title":str}];
}

@end
