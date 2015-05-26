//
//  IWHttpTool.m
//  ItcastWeibo
//
//  Created by apple on 14-5-19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "XMHttpTool.h"
#import "AFNetworking.h"

#define BaseUrl @"http://123.57.35.205:8866/index.php/mobile/"   //外网
//#define BaseUrl @"http://192.168.1.88/xiushenma/code/v1/index.php/mobile/"   //内网
@implementation XMHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr POST:webUrl parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          XMLog(@"------>%@",responseObject);
          
          NSString *error = responseObject[@"error"];
          NSString *str = [NSString stringWithFormat:@"%@,请重新登陆",error];
          if (error!=nil || error.length > 0) {
              XMLog(@"error---->%@",str);
              [MBProgressHUD showError:str];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthenticationFailed" object:nil];
          }
          
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr POST:webUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> totalFormData) {
        for (XMFormData *formData in formDataArray) {
            [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *error = responseObject[@"error"];
        NSString *str = [NSString stringWithFormat:@"%@,请重新登陆",error];
        XMLog(@"error---->%@",str);
        if (error!=nil || error.length > 0) {
            [MBProgressHUD showError:str];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthenticationFailed" object:nil];
        }
        
        
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *webUrl = [BaseUrl stringByAppendingString:url];
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 2.发送请求
    [mgr GET:webUrl parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          NSString *error = responseObject[@"error"];
          NSString *str = [NSString stringWithFormat:@"%@,请重新登陆",error];
          XMLog(@"error---->%@",str);
          if (error!=nil || error.length > 0) {
              [MBProgressHUD showError:str];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserAuthenticationFailed" object:nil];
          }
          
          
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

//- (void)uploadImage{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"1"]];
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    manager.requestSerializer.timeoutInterval = 60;
//
//    [manager POST:@"" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        UIImage *_userImage;
//        NSData *data=UIImagePNGRepresentation(_userImage);
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        
//        // 设置时间格式
//        
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//        
//        [formData appendPartWithFileData:data name:@"logo_img" fileName:fileName mimeType:@"image/png"];
//        
//        
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [super stopLoadingCompletedWithMessage:@"提交成功"];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        XMLog(@"%@",error);
//    }];
//}

@end

/**
 *  用来封装文件数据的模型
 */
@implementation XMFormData

@end
