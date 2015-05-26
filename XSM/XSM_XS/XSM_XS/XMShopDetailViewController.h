//
//  XMShopDetailViewController.h
//  XSM_XS
//
//  Created by Apple on 14/11/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@interface XMShopDetailViewController : XMBaseViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIButton *repairStyle1;
@property (strong, nonatomic) IBOutlet UIButton *repairStyle2;
@property (strong, nonatomic) IBOutlet UIButton *repairStyle3;


- (IBAction)orderCategory:(UIButton *)sender;


@property (nonatomic , copy ) NSString *maintainer_id;//修神ID

@end
