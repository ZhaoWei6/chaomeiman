//
//  TGImageTool.h
//  团购
//
//  Created by app04 on 14-7-26.
//  Copyright (c) 2014年 app04. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMImageTool : NSObject

+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView;
+ (void)clear;

@end
