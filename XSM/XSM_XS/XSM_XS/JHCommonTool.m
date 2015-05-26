//
//  JHCommonTool.m
//  XSM_XS
//
//  Created by Andy on 14-12-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "JHCommonTool.h"

@implementation JHCommonTool

+(BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
