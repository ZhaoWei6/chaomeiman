//
//  JHComAddCellFrame.h
//  XSM_XS
//
//  Created by Andy on 15/1/5.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class JHCommonAdress;

@interface JHComAddCellFrame : NSObject

@property (nonatomic, strong) JHCommonAdress *commonAddress;
/** 常用联系人信息 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 常用联系人详细地址 */
@property (nonatomic, assign, readonly) CGRect detailAddressLabelF;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
