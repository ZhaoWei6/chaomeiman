//
//  TGCategoryMenu.m
//  团购
//
//  Created by app04 on 14-7-24.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMCategoryMenu.h"
#import "XMMetaDataTool.h"
#import "XMCategory.h"

@interface XMCategoryMenu()
@end

@implementation XMCategoryMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        XMMetaDataTool *metaDataTool = [[XMMetaDataTool alloc] init];
        XMCategory *category = metaDataTool.currentCategory;
        NSArray *subcategories = category.subcategories;
        // 1.往scrollView里面添加内容
        NSInteger count = subcategories.count;
        for (int i = 0; i<count; i++) {
            // 创建item
            UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
            item.tag = i;
            // 设置按钮title样式
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            item.titleLabel.font = kRepairTextFont;
            item.titleLabel.textAlignment = NSTextAlignmentCenter;
            // 设置按钮title
            [item setTitle:subcategories[i] forState:UIControlStateNormal];
            // 添加事件
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            item.frame = CGRectMake(0, i*44, kDeviceWidth/3-8, 44);
            [_scrollView addSubview:item];
            // 默认选中第0个item
            if (i == 0) {
                item.selected = YES;
                _selectedItem = item;
            }
        }
        _scrollView.contentSize = CGSizeMake(0, (count+1)*44);
    }
    return self;
}


@end
