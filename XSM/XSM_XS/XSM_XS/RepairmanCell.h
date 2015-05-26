//
//  RepairmanCell.h
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMRepairman,XMRatingView;
@interface RepairmanCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *shopName;//店铺
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;//距离
@property (strong, nonatomic) IBOutlet UIImageView *photo;//头像
@property (strong, nonatomic) IBOutlet UILabel *specialLabel;//技能
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (strong, nonatomic) IBOutlet XMRatingView *ratingView;//评分
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;//已修数量

@property (nonatomic , retain) XMRepairman *repairman;
@property (nonatomic , copy ) NSString *maintainer_id;

//-(void) initializeCellWithItem:(XMRepairman *)repairman;

@end
