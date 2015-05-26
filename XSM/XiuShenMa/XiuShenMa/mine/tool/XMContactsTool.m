//
//  XMContactsTool.m
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMContactsTool.h"
#import "XMContacts.h"
#import "XMHttpTool.h"
#import "XMDealTool.h"
#import "XMLogin.h"
#import "NSObject+Value.h"
#import "XMReset.h"
#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Contacts.data"]

typedef void (^RequestBlock)(id result,NSError *errorObj);

@interface XMContactsTool ()
{
    NSMutableArray *_allContacts;
}

@end

@implementation XMContactsTool
singleton_implementation(XMContactsTool)

- (id)init
{
    if (self = [super init]) {
        // 1.加载沙盒中的联系人信息
        _allContacts = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
        
        // 2.第一次没有联系人信息
        if (_allContacts.count == 0) {
            _allContacts = [NSMutableArray array];
//            NSString *userid = [XMDealTool sharedXMDealTool].userid;
//            NSString *password = [XMDealTool sharedXMDealTool].password;
//            XMLog(@"%@%@",userid,password);
//            [XMHttpTool postWithURL:@"user/address" params:@{@"userid":userid,@"password":password} success:^(id json) {
//                NSArray *array = json[@"datalist"];
//                NSMutableArray *deals = [NSMutableArray array];
//                for (NSDictionary *dict in array) {
//                    XMContacts *d = [[XMContacts alloc] init];
//                    if (dict[@"sex"]) {
//                        d.sex = @"先生";
//                        continue ;
//                    }else{
//                        d.sex = @"女士";
//                        continue ;
//                    }
//                    [deals addObject:d];
//                    XMLog(@"================%@     %@",deals,d.sex);
//                }
//            } failure:^(NSError *error) {
//                XMLog(@"失败%@",error);
//            }];
        }
    }
    return self;
}

// 添加联系人信息
- (void)addContacts:(XMContacts *)contacts
{
    [_allContacts insertObject:contacts atIndex:0];
    [NSKeyedArchiver archiveRootObject:_allContacts toFile:kFilePath];
}

// 删除联系人信息
- (void)deleteContacts:(XMContacts *)contacts
{
    [_allContacts removeObject:contacts];
    [NSKeyedArchiver archiveRootObject:_allContacts toFile:kFilePath];
}



#pragma mark  	注册页面
-(void)dealWitParams:(NSDictionary *)dic Success:(LoginBlock)success{

    [XMHttpTool  postWithURL:@"register/registered" params:dic success:^(id json) {
        XMLog(@"注册信息%@",json);
        success(json);
    } failure:^(NSError *error) {
        XMLog(@"   asasd%@",error);
    }];
}




@end
