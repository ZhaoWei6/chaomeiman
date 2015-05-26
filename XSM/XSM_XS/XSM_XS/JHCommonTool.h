//
//  JHCommonTool.h
//  XSM_XS
//
//  Created by Andy on 14-12-11.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCommonTool : NSObject
/**
 *  验证是否是手机号
 *
 *  @return YES:手机号 NO：非手机号
 */
+(BOOL)isValidateMobile:(NSString *)mobile;
@end
