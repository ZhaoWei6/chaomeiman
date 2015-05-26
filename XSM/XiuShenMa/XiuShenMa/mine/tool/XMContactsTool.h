//
//  XMContactsTool.h
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
typedef void (^LoginBlock)(NSDictionary *deal);
typedef void (^registerBlock)(NSDictionary  *reset);

@class XMContacts;
@interface XMContactsTool : NSObject
singleton_interface(XMContactsTool)



@property (nonatomic, strong, readonly) NSArray *allContacts;

@property (nonatomic, retain) XMContacts *currentContacts;

@property(nonatomic,retain) NSString *mobile;
@property(nonatomic,retain) NSString *password;
@property(nonatomic,retain) NSString *verify;
@property (nonatomic, strong) NSString *userid;


// 添加联系人信息
- (void)addContacts:(XMContacts *)contacts;

// 删除联系人信息
- (void)deleteContacts:(XMContacts *)contacts;

#pragma mark  	注册页面

-(void)dealWitParams:(NSDictionary *)dic Success:(LoginBlock)success;



@end
