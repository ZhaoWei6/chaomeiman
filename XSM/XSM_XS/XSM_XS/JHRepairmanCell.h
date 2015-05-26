//
//  JHRepairmanCell.h
//  XSM_XS
//
//  Created by Andy on 15/1/12.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMRepairman;

@interface JHRepairmanCell : UITableViewCell

@property (nonatomic, strong) XMRepairman *repairman;

+ (instancetype)repairmanCellWithTableView:(UITableView *)tableView;

@end
