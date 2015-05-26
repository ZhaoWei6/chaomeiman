//
//  LoginUser.h
//  企信通
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <CommonCrypto/CommonDigest.h>
@interface LoginUser : NSObject
single_interface(LoginUser)

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *hostName;

@property (strong, nonatomic) NSString *longitu;
@property (strong, nonatomic) NSString *latitu;
//用户手机号
@property (strong, nonatomic) NSString *member_phone;
//用户头像
@property (strong, nonatomic) NSString *member_head;
//用户ID
@property (strong, nonatomic) NSString *member_id;
//用户姓名
@property (strong, nonatomic) NSString *member_nickname;
//用户性别
@property (strong, nonatomic) NSString *member_gender;
//用户年龄
@property (strong, nonatomic) NSString *member_age;
//用户健康描述
@property (strong, nonatomic) NSString *member_health_description;
//专家改用户名字
@property (strong, nonatomic) NSString *changeName;
//点击行数
@property (strong, nonatomic) NSString *selectNumber;

@property (strong, nonatomic, readonly) NSString *myJIDName;

@property(nonatomic,assign) NSInteger messageNum;
@property (strong,nonatomic)NSDictionary * messageNumDic;
//post
- (void)loadurl:(NSString *)urlstring with:(NSDictionary *)dic BlockWithSuccess:(void (^__strong)(__strong id))success Failure:(void (^)(NSError *mes))failure;

//postimage 没进度
-(void)postToServerWithUrl:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *mes))failure;

//postimage
-(void)postToServerWithField:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *))failure;

-(void)postToServerWithField1:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *))failure;

//get
- (void)loadgeturl:(NSString *)urlstring with:(NSDictionary *)dic BlockWithSuccess:(void (^__strong)(__strong id))success Failure:(void (^)( NSError *mes))failure;

#pragma mark -- md5加密
- (NSString *)md5:(NSString *)str;
#pragma mark -- SHA1加密
- ( NSString *)getSha1String:( NSString *)srcString;
@end
