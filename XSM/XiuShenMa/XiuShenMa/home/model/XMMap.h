//
//  XMMap.h
//  XiuShenMa
//
//  Created by Apple on 14/12/3.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMap : NSObject

//@property (nonatomic , copy)  NSString *maintainer_id;//修神id 进入下个页面用

@property (nonatomic , copy)  NSString *nickname;//修神名
@property (nonatomic , copy)  NSString *photo;//修神头像
@property (nonatomic , assign)CGFloat   evaluate;//评分
@property (nonatomic , copy)  NSString *maintainer_id;//修神ID
@property (nonatomic , assign) double  longitude;//经度
@property (nonatomic , assign) double  latitude;//纬度

@end
