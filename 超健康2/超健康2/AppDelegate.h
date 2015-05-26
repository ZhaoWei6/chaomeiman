//
//  AppDelegate.h
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
//分享功能
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
#import <QZoneConnection/ISSQZoneApp.h>

#import "XMPPFramework.h"
#import <AudioToolbox/AudioToolbox.h>

#define xmppDelegate (AppDelegate *)[[UIApplication sharedApplication] delegate]

typedef void(^CompletionBlock)();

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

#pragma mark - XMPP属性及方法
/**
 *  全局的XMPPStream，只读属性    //xmpp基础服务类
 */
@property (strong, nonatomic, readonly) XMPPStream *xmppStream;
/**
 *  全局的xmppvCard模块，只读属性    //好友名片实体类，从数据库里取出来的都是它
 */
@property (strong, nonatomic, readonly) XMPPvCardTempModule *xmppvCardModule;
/**
 *  全局的XMPPvCardAvatar模块，只读属性     //好友头像
 */
@property (strong, nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
/**
 *  全局的xmppRoster模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPRoster *xmppRoster;  //好友列表类
/**
 *  全局的XMPPRosterCoreDataStorage模块，只读属性      //好友列表（用户账号）在core data中的操作类
 */
@property (strong, nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

/**
 *  消息存档（归档）模块，只读属性
 */
@property (strong, nonatomic, readonly) XMPPMessageArchiving *xmppMessageArchiving;
@property (strong, nonatomic, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

/**
 *  传输文件socket数组
 */
@property (strong, nonatomic) NSMutableArray *socketList;

/**
 *  是否注册用户标示
 */
@property (assign, nonatomic) BOOL isRegisterUser;

/**
 *  连接到服务器
 *
 *  注释：用户信息保存在系统偏好中
 *
 *  @param completion 连接正确的块代码
 *  @param faild      连接错误的块代码
 */
@property (nonatomic) SSInterfaceOrientationMask interfaceOrientationMask;

- (void)connectWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild;

/**
 *  注销用户登录
 */
// 设置XMPPStream
- (void)setupStream;
// 销毁XMPPStream并注销已注册的扩展模块
- (void)teardownStream;
// 通知服务器器用户上线
- (void)goOnline;
// 通知服务器器用户下线
- (void)goOffline;
// 连接到服务器
- (void)connect;
// 与服务器断开连接

- (void)disconnect;

- (void)logout;

-(void)loadSevice;

@end

UITabBarItem *messageFlag;
