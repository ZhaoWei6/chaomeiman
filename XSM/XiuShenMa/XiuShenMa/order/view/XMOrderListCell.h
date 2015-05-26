//
//  XMOrderListCell.h
//  XiuShenMa
//
//  Created by Apple on 15/1/23.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMOrderListCell : UITableViewCell

//+ (instancetype)initWithTableView:(UITableView *)tableView andIdentifier:(NSString *)identifier;

@property (nonatomic , strong) NSDictionary *orderDetail;

@end
