//
//  XMLoginViewController.h
//  XSM_XS
//
//  Created by Apple on 14/12/1.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@interface XMLoginViewController : XMBaseViewController

@property(nonatomic, assign) BOOL isModal;

@property (strong, nonatomic) IBOutlet UISegmentedControl *seg;

@property (strong, nonatomic) IBOutlet UIScrollView *contentView;

- (IBAction)loginOrResgin:(UISegmentedControl *)sender;

@end
