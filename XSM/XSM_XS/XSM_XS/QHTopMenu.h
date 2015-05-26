//
//  QHTopMenu.h
//  Demo
//
//  Created by Apple on 15/1/16.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QHTopMenuItemClickDelegete <NSObject>

- (void)clickItemWithItem:(NSString *)item;

@end

@interface QHTopMenu : UIView

+ (instancetype)initQHTopMenuWithTitles:(NSArray *)titles frame:(CGRect)frame delegate:(id)delegate;

@end
