//
//  TGDealTopMenu.m
//  团购
//
//  Created by app04 on 14-7-24.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import "XMDealTopMenu.h"
#import "XMDealBottomMenu.h"
#import "XMDealTopMenuItem.h"

#import "XMCategoryMenu.h"
#import "XMOrderMenu.h"
#import "XMCategory.h"
#import "XMOrder.h"

#import "XMMetaDataTool.h"
@interface XMDealTopMenu()
{
    XMDealBottomMenu  *_showingMenu; // 正在展示的底部菜单
    XMDealTopMenuItem *_selectedItem;// 记录点击的按钮
}
@end
@implementation XMDealTopMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (categoryStyle == 0) {
            [self addMenuItem:@"机型" index:0];
        }else if (categoryStyle == 2){
            [self addMenuItem:@"锁型" index:0];
        }
        [self addMenuItem:@"全城" index:1];
        [self addMenuItem:@"默认排序" index:2];
        
        kAddAllNotes(dataChange)
    }
    return self;
}

#pragma mark 添加一个菜单项
- (void)addMenuItem:(NSString *)title index:(int)index
{
    //实例化XMDealTopMenuItem对象
    XMDealTopMenuItem *item = [[XMDealTopMenuItem alloc] init];
    //设置标题
    item.title = title;
    item.tag = index;
    //设置位置
    item.frame = CGRectMake(self.width/3 * index, 0, self.width/3, self.height);

    //按钮后边的分割线
    UIImageView *divider = [[UIImageView alloc] initWithFrame:CGRectMake(item.width, 5, 2, self.height - 10)];
    divider.backgroundColor = [UIColor darkGrayColor];
    [item addSubview:divider];
    //添加事件
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    
    //
}

#pragma mark 监听顶部item的点击
// _selectedItem -》 默认排序
// item -》默认排序
- (void)itemClick:(XMDealTopMenuItem *)item
{
    _selectedItem.selected = NO;
    if (_selectedItem == item) {
        _selectedItem = nil;
        [self hideBottomMenu];
    }else{
        item.selected = YES;
        _selectedItem = item;
        [self showBottomMenu:item];
    }
}

#pragma mark 显示底部菜单
- (void)showBottomMenu:(XMDealTopMenuItem *)item
{
    [_showingMenu removeFromSuperview];
    // 实例化一个底部视图对象
//    _showingMenu = [[XMDealBottomMenu alloc] init];
    
    if (item.tag == 0) {
        _showingMenu = [[XMCategoryMenu alloc] init];
        _showingMenu.height = 44*4;
    }else if (item.tag == 1){
        _showingMenu.height = 0;
    }else{
        _showingMenu = [[XMOrderMenu alloc] init];
        _showingMenu.height = 44*3;
    }
    
    // 设置_showimgMenu的位置和大小
    _showingMenu.left = item.left+4;
    _showingMenu.top = 64+44;
    _showingMenu.width = item.width-8;
    _showingMenu.clipsToBounds = YES;
    
    // 设置block回调
    __unsafe_unretained XMDealTopMenu *menu = self;
    _showingMenu.hideBlock = ^{
        
        // 1.取消选中当前的item
        menu->_selectedItem.selected = NO;
        menu->_selectedItem = nil;
        
        // 2.清空正在显示的菜单
        menu->_showingMenu = nil;
    };
    
    [_contentView addSubview:_showingMenu];
    [_showingMenu show];
}

#pragma mark 隐藏底部菜单
- (void)hideBottomMenu
{
    [_showingMenu hide];
    _showingMenu = nil;
}

- (void)dataChange
{
    // 1.分类按钮
    NSString *c = [XMMetaDataTool sharedXMMetaDataTool].currentCategoryTitle;
    if (_selectedItem.tag == 0) {
        _selectedItem.title = c;
    }
    
    // 2.商区按钮
    
    // 3.排序按钮
    NSString *o = [XMMetaDataTool sharedXMMetaDataTool].currentOrderTitle;
    if (_selectedItem.tag == 2) {
        _selectedItem.title = o;
    }
    
    _selectedItem.selected = NO;
    _selectedItem = nil;
    
    // 4.隐藏底部菜单
    [_showingMenu hide];
    _showingMenu = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



