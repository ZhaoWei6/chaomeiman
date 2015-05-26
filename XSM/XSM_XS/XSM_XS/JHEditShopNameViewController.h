//
//  JHEditShopNameViewController.h
//  XSM_XS
//
//  Created by Andy on 14-12-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
@class JHEditShopNameViewController;

@protocol JHEditShopNameViewDelegate <NSObject>

@optional
- (void)editShopNameViewController:(JHEditShopNameViewController *)editShopNameViewController didSaveShopName:(NSString *)shopName;

@end

@interface JHEditShopNameViewController : XMBaseViewController

@property(nonatomic, weak) id <JHEditShopNameViewDelegate> delegate;

@end
