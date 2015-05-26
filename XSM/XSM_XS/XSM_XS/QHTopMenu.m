//
//  QHTopMenu.m
//  Demo
//
//  Created by Apple on 15/1/16.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import "QHTopMenu.h"
#import "XMCommon.h"
#import "UIViewExt.h"

@interface QHTopMenu ()
{
    UIButton *_selectItem;
}
@property (nonatomic, assign) CGFloat item_Width;
@property (nonatomic, assign) CGFloat item_Height;
@property (nonatomic, assign) id<QHTopMenuItemClickDelegete>delegate;

@end

@implementation QHTopMenu

+ (instancetype)initQHTopMenuWithTitles:(NSArray *)titles frame:(CGRect)frame delegate:(id)delegate
{
    QHTopMenu *topView = [[QHTopMenu alloc] initWithFrame:frame];
    
    topView.layer.borderWidth = 1;
    topView.layer.borderColor = kBorderColor.CGColor;
    topView.backgroundColor = [UIColor whiteColor];
    
//    [topView makeInsetShadowWithRadius:1 Color:kBorderColor Directions:@[@"bottom"]];
    
    topView.delegate = delegate;
    topView.item_Width = (CGFloat)frame.size.width / (titles.count);
    topView.item_Height = frame.size.height;
    
    for (int i=0; i<titles.count; i++) {
        UIButton *item = [UIButton buttonWithType:UIButtonTypeSystem];
        
        [item setExclusiveTouch:YES];
        
        [item setBackgroundColor:[UIColor clearColor]];
        [item setTag:i];
        [item setTitle:titles[i] forState:UIControlStateNormal];
        
        [item setTitleColor:kTextFontColor666 forState:UIControlStateNormal];
        [item setTitleColor:XMButtonBg forState:UIControlStateDisabled];
        
        item.frame = CGRectMake(topView.item_Width*i, 0, topView.item_Width, topView.item_Height);
        
        [item addTarget:topView action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [topView addSubview:item];
        
        if (i == 0) {
            [topView clickItem:item];
        }
        
        if (i != titles.count-1) {
            UIImageView *sep = [[UIImageView alloc] initWithFrame:CGRectMake(item.right-0.5f, (topView.item_Height-24)/2.0f, 1, 24)];
            [sep setImage:[UIImage imageNamed:@"line_03"]];
            [topView addSubview:sep];
        }
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topView.item_Height-3, topView.item_Width, 2)];
    bottomLine.tag = 100;
    bottomLine.backgroundColor = XMButtonBg;
    [topView addSubview:bottomLine];
    [topView bringSubviewToFront:bottomLine];
    
    return topView;
}

- (void)clickItem:(UIButton *)item
{
    item.enabled = NO;
    _selectItem.enabled = YES;
    _selectItem = item;
    
    UIView *bottomLine = [[item superview] viewWithTag:100];
    [UIView animateWithDuration:0.2 animations:^{
        bottomLine.frame = CGRectMake(item.frame.origin.x, self.item_Height-3, self.item_Width, 2);
    }];
//    NSLog(@"点击了第%ld个项",item.tag);
    
    NSString *str = item.titleLabel.text;
    if ([self.delegate respondsToSelector:@selector(clickItemWithItem:)]) {
        [self.delegate clickItemWithItem:str];
    }
}

@end
