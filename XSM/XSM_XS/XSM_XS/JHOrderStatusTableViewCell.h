//
//  JHOrderStatusTableViewCell.h
//  XSM_XS
//
//  Created by Andy on 14-12-4.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHOrderStatusTableViewCell : UITableViewCell

@property(nonatomic, strong) NSDictionary *dictionary;
@property(nonatomic, strong) NSDictionary *defaultDictionary;
@property(nonatomic, assign) BOOL isLast;

+ (instancetype)orderStatusTableViewCellWithTableView:(UITableView *)tableView;

@end
