//
//  JHCommonAddressViewController.h
//  XSM_XS
//
//  Created by Andy on 14-12-10.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
@class JHCommonAdress, JHCommonAddressViewController;

@protocol JHCommonAddressViewControllerDelegate <NSObject>

@optional
- (void)commonAddressViewController:(JHCommonAddressViewController *)commonAddressViewController didSaveCommonAddress:(JHCommonAdress *)commonAdress;

@end

@interface JHCommonAddressViewController : XMBaseViewController

@property(nonatomic, weak) id <JHCommonAddressViewControllerDelegate>delegate;
@property (nonatomic, assign) BOOL isDisplay;

@end
