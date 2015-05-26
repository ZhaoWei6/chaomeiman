//
//  XMUserResponseViewController.h
//  XSM_XS
//
//  Created by Apple on 14/12/8.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import "XMPlaceHolderTextView.h"
@interface XMUserResponseViewController : XMBaseViewController

@property (strong, nonatomic) IBOutlet XMPlaceHolderTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)actionSubmit:(UIButton *)sender;

@end
