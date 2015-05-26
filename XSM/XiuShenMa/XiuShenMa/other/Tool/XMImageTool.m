//
//  TGImageTool.m
//  团购
//
//  Created by app04 on 14-7-26.
//  Copyright (c) 2014年 app04. All rights reserved.
//




//异步加载图片  对图片进行缓存处理，便于清空缓存  处理错误图像的加载信息
//在沙盒下建立缓存区
#import "XMImageTool.h"
#import "SDImageCache.h"

@implementation XMImageTool

+ (void)downloadImage:(NSString *)url placeholder:(UIImage *)place imageView:(UIImageView *)imageView
{
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

+ (void)clear
{
    // 1.清除内存中的缓存图片
//    [[SDImageCache sharedImageCache] clearMemory];
    
    // 2.取消所有的下载请求
//    [[SDWebImageManager sharedManager] cancelAllOperations];
}

@end
