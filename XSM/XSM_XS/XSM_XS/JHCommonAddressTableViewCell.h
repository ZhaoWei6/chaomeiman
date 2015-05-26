//
//  JHCommonAddressTableViewCell.h
//  XSM_XS
//
//  Created by Andy on 14-12-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCommonAdress.h"
@class JHCommonAddressTableViewCell;

@protocol JHCommonAddressTableViewCellDelegate <NSObject>

@optional
- (void)commonAddressCell:(JHCommonAddressTableViewCell *)commonAddressCell didSelectEditButton:(UIButton *)button;

@end

@interface JHCommonAddressTableViewCell : UITableViewCell

@property(nonatomic, strong) JHCommonAdress *commonAdress;

@property(nonatomic, weak) id <JHCommonAddressTableViewCellDelegate>delegate;

+ (instancetype)commonAddressTableViewCellWithTableView:(UITableView *)tableView;
@end
