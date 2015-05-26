//
//  ViewController.h
//  XSM_XS
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMCommon.h"
#import "Measurement.h"
#import "UIViewExt.h"
#import "XMHttpTool.h"
#import "XMDealTool.h"

#import "BaseAnimation.h"
#import "ModalAnimation.h"
#import "XMKeyboardAvoidingScrollView.h"

#import "UIImageView+WebCache.h"
#import "UIScrollView+Touch.h"
#import "MBProgressHUD+MJ.h"
#import "NSObject+Value.h"

#import "JHCommonTool.h"

#import "AFNetworking.h"

#import "XMNavigationViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIColor+XM.h"

@interface XMBaseViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate,UINavigationControllerDelegate>
{
@public
    CGRect frame_first;
    UIImageView *fullImageView;
    NSTimer *timer;
}


#pragma mark - camera utility
- (BOOL) isCameraAvailable;
- (BOOL) isRearCameraAvailable;
- (BOOL) isFrontCameraAvailable;
- (BOOL) doesCameraSupportTakingPhotos;
- (BOOL) isPhotoLibraryAvailable;
- (BOOL) canUserPickVideosFromPhotoLibrary;
- (BOOL) canUserPickPhotosFromPhotoLibrary;
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;
#pragma mark 压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
#pragma mark 从文档目录下获取Documents路径
- (NSString *)documentFolderPath;
#pragma mark 上传
- (void)uplodeUserImage:(NSString *)imageName url:(NSString *)url;
#pragma mark 添加额外商品或服务
- (void)uplodeGoodsImageWithParams:(NSDictionary *)param url:(NSString *)url;
#pragma mark 显示全屏
- (void)touchImageViewWithImage:(UIImage *)image;
#pragma mark 取消全屏
-(void)actionTap2:(UITapGestureRecognizer *)sender;
@end

