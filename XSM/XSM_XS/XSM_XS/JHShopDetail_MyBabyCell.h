//
//  JHShopDetail_MyBabyCell.h
//  XSM_XS
//
//  Created by Andy on 14-12-12.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHShopDetail;

@interface JHShopDetail_MyBabyCell : UITableViewCell

@property(nonatomic, strong) JHShopDetail *shopDetail;

+ (instancetype)shopDetail_MyBabyCellWithTableView:(UITableView *)tableView;

@end
