//
//  JHOrderListCell.h
//  XSM_XS
//
//  Created by Andy on 15/1/22.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMOrder;

@interface JHOrderListCell : UITableViewCell

@property(nonatomic, copy) NSString *buttontitle;
@property(nonatomic, strong) XMOrder *order;

+ (instancetype)ordersListCellWithTableView:(UITableView *)tableView;

@end
