//
//  LoginUser.m
//  企信通
//
//  Created by apple on 13-11-30.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "LoginUser.h"
#import "NSString+Helper.h"
#import "AFNetworking.h"
#import "FMDB.h"
#define dataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"user.db"]

@implementation LoginUser
single_implementation(LoginUser)

#pragma mark - 私有方法
- (NSString *)loadStringFromDefaultsWithKey:(NSString *)key
{
    NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:key];
    
    return (str) ? str : @"";
}

#pragma mark - getter & setter
- (NSString *)userName
{
    return [self loadStringFromDefaultsWithKey:kXMPPUserNameKey];
}

- (void)setUserName:(NSString *)userName
{
    [userName saveToNSDefaultsWithKey:kXMPPUserNameKey];
}

- (NSString *)password
{
    return [self loadStringFromDefaultsWithKey:kXMPPPasswordKey];
}

- (void)setPassword:(NSString *)password
{
    [password saveToNSDefaultsWithKey:kXMPPPasswordKey];
}

- (NSString *)hostName
{
    return [self loadStringFromDefaultsWithKey:kXMPPHostNameKey];
}

- (void)setHostName:(NSString *)hostName
{
    [hostName saveToNSDefaultsWithKey:kXMPPHostNameKey];
}

- (NSString *)myJIDName
{
    return [NSString stringWithFormat:@"%@@%@", self.userName, kHostName];
}
//用户手机号
-(NSString *)member_phone{
    return [self loadStringFromDefaultsWithKey:Member_phone];
}

-(void)setMember_phone:(NSString *)member_phone{
    [member_phone saveToNSDefaultsWithKey:Member_phone];
}

-(NSString *)member_head{
    return [self loadStringFromDefaultsWithKey:Member_head];
}

-(void)setMember_head:(NSString *)member_head{
    [member_head saveToNSDefaultsWithKey:Member_head];
}

-(NSString *)member_id{
    return [self loadStringFromDefaultsWithKey:Member_id];
}

-(void)setMember_id:(NSString *)member_id{
    [member_id saveToNSDefaultsWithKey:Member_id];
}

-(NSString *)member_nickname{
    return [self loadStringFromDefaultsWithKey:Member_nickname];
}

-(void)setMember_nickname:(NSString *)member_nickname{
    [member_nickname saveToNSDefaultsWithKey:Member_nickname];
}

-(NSString *)member_gender{
    return [self loadStringFromDefaultsWithKey:Member_gender];
}

-(void)setMember_gender:(NSString *)member_gender{
    [member_gender saveToNSDefaultsWithKey:Member_gender];
}

-(NSString *)member_age{
    return [self loadStringFromDefaultsWithKey:Member_age];
}

-(void)setMember_age:(NSString *)member_age{
    [member_age saveToNSDefaultsWithKey:Member_age];
}

-(NSString *)member_health_description{
    return [self loadStringFromDefaultsWithKey:Member_health_description];
}

-(void)setMember_health_description:(NSString *)member_health_description{
    [member_health_description saveToNSDefaultsWithKey:Member_health_description];
}

-(NSString *)changeName{
    return [self loadStringFromDefaultsWithKey:ChangeName];
}

-(void)setChangeName:(NSString *)changeName{
    [changeName saveToNSDefaultsWithKey:ChangeName];
}

-(NSString *)selectNumber{
    return [self loadStringFromDefaultsWithKey:SelectNumber];
}

-(void)setSelectNumber:(NSString *)selectNumber{
    [selectNumber saveToNSDefaultsWithKey:SelectNumber];
}

//消息条数
-(void)setMessageNum:(NSInteger)messageNum
{
    [[NSUserDefaults standardUserDefaults] setInteger:messageNum forKey:MessageNum];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)messageNum
{
    return  [[NSUserDefaults standardUserDefaults] integerForKey:MessageNum];
}
-(void)setMessageNumDic:(NSDictionary *)messageNumDic
{
    [[NSUserDefaults standardUserDefaults] setObject:messageNumDic forKey:MessageNumArr];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSDictionary *)messageNumDic
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:MessageNumArr];
}


- (NSString *)longitu
{
    return [self loadStringFromDefaultsWithKey:Longitu];
}

- (void)setLongitu:(NSString *)longitu
{
    [longitu saveToNSDefaultsWithKey:Longitu];
}

- (NSString *)latitu
{
    return [self loadStringFromDefaultsWithKey:Latitu];
}

- (void)setLatitu:(NSString *)latitu
{
    [latitu saveToNSDefaultsWithKey:Latitu];
}


#pragma mark ===================afnetworking===============
//post
#pragma mark - post方法请求数据
- (void)loadurl:(NSString *)urlstring with:(NSDictionary *)dic BlockWithSuccess:(void (^__strong)(__strong id))success Failure:(void (^)( NSError *mes))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlstring parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success((NSDictionary *)responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"读取失败%@",error);
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - post方法服务器发送图片
//postImage 直接传送
-(void)postToServerWithUrl:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlstring parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MyLog(@"上传文件成功%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        MyLog(@"上传文件失败%@",error);
    }];
}



//postimage  有净度
#pragma mark - post方法服务器发送图片（带进度）
-(void)postToServerWithField:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *))failure
{
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]
                             multipartFormRequestWithMethod:@"POST" URLString:urlstring parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                 [formData appendPartWithFileData:fileData name:@"user_head" fileName:fileName mimeType:@"image/png"];
                             } error:nil];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dic);
            
        }
        NSLog(@"上传文件成功%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传文件失败 %@", error);
    }];
    
    // 4. operation start
    [op start];
}

-(void)postToServerWithField1:(NSString *)urlstring parameters:(NSDictionary *)parameters fileData:(NSData *)fileData fileName:(NSString *)fileName success:(void (^__strong)(__strong id))success failure:(void (^)(NSError *))failure
{
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer]
                             multipartFormRequestWithMethod:@"POST" URLString:urlstring parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                 [formData appendPartWithFileData:fileData name:@"pic" fileName:fileName mimeType:@"image/png"];
                             } error:nil];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dic);
        }
        NSLog(@"上传文件成功%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传文件失败 %@", error);
    }];
    
    // 4. operation start
    [op start];
}

//get
#pragma mark - get方法请求服务器
- (void)loadgeturl:(NSString *)urlstring with:(NSDictionary *)dic BlockWithSuccess:(void (^__strong)(__strong id))success Failure:(void (^)( NSError *mes))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlstring parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success((NSDictionary *)responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"读取失败%@",error);
        if (failure) {
            failure(error);
        }
    }];
    
}


#pragma mark ===================md5===============
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark -- SHA1加密
- ( NSString *)getSha1String:( NSString *)srcString{
    
    const char *cstr = [srcString cStringUsingEncoding : NSUTF8StringEncoding ];
    NSData *data = [ NSData dataWithBytes :cstr length :srcString. length ];
    uint8_t digest[ CC_SHA1_DIGEST_LENGTH ];
    CC_SHA1 (data. bytes , data. length , digest);
    NSMutableString * result = [ NSMutableString stringWithCapacity : CC_SHA1_DIGEST_LENGTH * 2 ];
    for ( int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; i++) {
        [result appendFormat : @"%02x" , digest[i]];
    }
    return result;
}


#pragma mark ===================数据库===============
////数据库
-(void)createTable{
    //创建表
    NSLog(@"%@dataPath",dataPath);
    FMDatabase *data=[FMDatabase databaseWithPath:dataPath];
    if (![data open]) {
        [data close];
    }
    data.shouldCacheStatements=YES;
    if (![data tableExists:@"userInfo"]) {
        [data executeUpdate:@"create table userInfo (ID text,name text,age text)"];
    }
    [data close];
}
-(void)insertContactWithContact{
    FMDatabase *data=[FMDatabase databaseWithPath:dataPath];
    if (![data open]) {
        [data close];
    }
    data.shouldCacheStatements=YES;
    //插入
    if ([data open]) {
        [data executeUpdate:@"insert into collection (ID,name,age) values ('1','zhaowei2','16')"];
        [data executeUpdate:@"insert into collection (ID,name,age) values('2','zhaowei3','15')"];
    }
    [data close];
}
-(void)deleteContactWithName{
    FMDatabase *data=[FMDatabase databaseWithPath:dataPath];
    if (![data open]) {
        [data close];
    }
    data.shouldCacheStatements=YES;
    if ([data open]) {
        [data executeUpdate:@"delete from collection where ID='1'"];
    }
    [data close];
    
}
-(void)updateContactWithName{
    FMDatabase *data=[FMDatabase databaseWithPath:dataPath];
    if (![data open]) {
        [data close];
    }
    data.shouldCacheStatements=YES;
    if ([data open]) {
        [data executeUpdate:@"update collection set ID='1' where ID='一' "];
    }
    [data close];
}
-(void)queryData{
    FMDatabase *data=[FMDatabase databaseWithPath:dataPath];
    if (![data open]) {
        [data close];
    }
    data.shouldCacheStatements=YES;
    if ([data open]) {
        FMResultSet *set=[data executeQuery:@"select * from collection"];
        while ([set next]) {
            NSString *iD=[set stringForColumn:@"ID"];
            NSString *name=[set stringForColumn:@"name"];
            NSString *age=[set stringForColumn:@"age"];
            NSLog(@"id=%@,name=%@,age=%@",iD,name,age);
        }
    }
    [data close];
}

@end
