//
//  XMAddressViewController.h
//  XSM_XS
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"

@interface XMAddressViewController : XMBaseViewController

@property (strong, nonatomic) IBOutlet UITextField *area;
@property (strong, nonatomic) IBOutlet UITextField *address;

@property (strong, nonatomic) IBOutlet UITextField *phone;


- (IBAction)chooseAddress:(UITextField *)sender;

@end
