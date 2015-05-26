//
//  JHOrdersTableViewCell.h
//  XSM_XS
//
//  Created by Andy on 14-12-3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMOrder;
@interface JHOrdersTableViewCell : UITableViewCell

@property(nonatomic, copy) NSString *buttontitle;
@property(nonatomic, strong) XMOrder *order;

+ (instancetype)ordersTableViewCellWithTableView:(UITableView *)tableView;


@end
