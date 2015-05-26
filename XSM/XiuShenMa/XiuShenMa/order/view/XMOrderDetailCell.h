//
//  XMOrderDetailCell.h
//  XiuShemMa
//
//  Created by Apple on 14-10-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMOrderRatingDelegate <NSObject>

- (void)clickButton:(NSString *)str orderid:(NSNumber *)orderid isIntoShop:(BOOL)isIntoShop;

@end

//@class XMOrderDetail;
@interface XMOrderDetailCell : UITableViewCell

@property (nonatomic , retain) NSDictionary *orderDetail;
@property (nonatomic , assign) BOOL isRating;


@property (nonatomic , assign) id <XMOrderRatingDelegate> delegate;

@end
