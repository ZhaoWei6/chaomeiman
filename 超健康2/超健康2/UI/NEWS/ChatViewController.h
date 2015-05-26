//
//  ChatViewController.h
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-22.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ChatViewController : BaseController
// 对话方JID
@property (strong, nonatomic) NSString *bareJidStr;
@property (strong, nonatomic) NSString *bareName;
@property (strong, nonatomic) NSString *bareId;
// 对话方头像
@property (strong, nonatomic) UIImage *bareImage;
@property (strong, nonatomic) NSString *bareImageUrl;
// 我的头像
@property (strong, nonatomic) UIImage *myImage;
@property (strong, nonatomic) NSString *myImageUrl;
//
@property (assign, nonatomic) int number;
@end
