//
//  TGOrderMenu.m
//  团购
//
//  Created by app04 on 14-7-24.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMOrderMenu.h"

#import "XMMetaDataTool.h"
#import "XMOrder.h"
@implementation XMOrderMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.往UIScrollView添加内容
        NSArray *orders = [XMMetaDataTool sharedXMMetaDataTool].totalOrders;
        NSInteger count = orders.count;
        
        for (int i = 0; i<count; i++) {
            // 创建排序item
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.tag = 2000+i;
            // 设置按钮title样式
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            item.titleLabel.font = kRepairTextFont;
            item.titleLabel.textAlignment = NSTextAlignmentCenter;
            // 给按钮添加title
            NSString *str = [orders[i] name];
            [item setTitle:str forState:UIControlStateNormal];
            // 添加事件
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            item.frame = CGRectMake(0, i*44, kDeviceWidth/3-8, kUIButtonHeight);
            [_scrollView addSubview:item];
            
            // 默认选中第0个item
            if (i == 0) {
                item.selected = YES;
                _selectedItem = item;
            }
        }
        _scrollView.contentSize = CGSizeMake(0, count*44);
        
    }
    return self;
}


@end
