//
//  XMRepairmanCell.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMRepairman;
@interface XMRepairmanCell : UITableViewCell

@property (nonatomic , retain) XMRepairman *repairman;
@property (nonatomic , copy ) NSString *maintainer_id;

@end
