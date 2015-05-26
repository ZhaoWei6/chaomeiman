//
//  AppDelegate.m
//  Chaomeiman 专家端
//
//  Created by imac on 14-12-10.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "DXAlertView.h"
#import "LaunchViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
#import "NSString+Helper.h"
#import "NSData+XMPP.h"
#define kNotificationUserLogonState @"NotificationUserLogon"
#define ROOM_JID @"ROOM_JID"

#import "MobClick.h"

@interface AppDelegate() <XMPPStreamDelegate, XMPPRosterDelegate, TURNSocketDelegate>
{
    CompletionBlock             _completionBlock;       // 成功的块代码
    CompletionBlock             _faildBlock;            // 失败的块代码
    
    XMPPReconnect               *_xmppReconnect;        // XMPP重新连接XMPPStream
    XMPPvCardCoreDataStorage    *_xmppvCardStorage;     // 电子名片的数据存储模块
    
    XMPPCapabilities            *_xmppCapabilities;     // 实体扩展模块
    XMPPCapabilitiesCoreDataStorage *_xmppCapabilitiesCoreDataStorage; // 数据存储模块
}

// 设置XMPPStream
- (void)setupStream;
// 销毁XMPPStream并注销已注册的扩展模块
//- (void)teardownStream;
// 通知服务器器用户上线
- (void)goOnline;
// 通知服务器器用户下线
- (void)goOffline;
// 连接到服务器
- (void)connect;
// 与服务器断开连接
- (void)disconnect;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        //IOS8
        //创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:notiSettings];
        
    } else{ // ios7
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
    }
    application.applicationIconBadgeNumber = 0;
    
    [self.window makeKeyAndVisible];
#pragma mark --------1.ShareSDK------
    /**
     注册SDK应用，此应用请到http://www.sharesdk.cn中进行注册申请。
     此方法必须在启动时调用，否则会限制SDK的使用。
     **/
    [ShareSDK registerApp:@"544a029254fb"];
    
    //如果使用服务中配置的app信息，请把初始化代码改为下面的初始化方法。
    //    [ShareSDK registerApp:@"iosv1101" useAppTrusteeship:YES];
    [self initializePlat];
    
    //如果使用服务器中配置的app信息，请把初始化平台代码改为下面的方法
    //    [self initializePlatForTrusteeship];
    
    _interfaceOrientationMask = SSInterfaceOrientationMaskAll;
    
    //横屏设置
    //        [ShareSDK setInterfaceOrientationMask:UIInterfaceOrientationMaskLandscape];
    
    //开启QQ空间网页授权开关
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
    //    //监听用户信息变更
    //    [ShareSDK addNotificationWithName:SSN_USER_INFO_UPDATE
    //                               target:self
    //                               action:@selector(userInfoUpdateHandler:)];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    
#pragma mark  --------------1.1 UMeng---------
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
#pragma mark  --------------2.XMPP登录--------
    //--------XMPP------
    
    // 1. 设置XMPPStream
    [self setupStream];
    
    // 2. 实例化socket数组
    _socketList = [NSMutableArray array];
    
    // 3.登录
    [self loadSevice];
    return YES;
}
- (void)initializePlat
{
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104090905"
                           appSecret:@"lJeiKGndEiqddGY0"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
    //                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
    //                           wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wxcd49c90c7d4ae142"
                           appSecret:@"547bb6ed397bee772c7795e4f2df1c43"
                           wechatCls:[WXApi class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    
    [ShareSDK connectQQWithQZoneAppKey:@"1104090905"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    return self.interfaceOrientationMask;
    return SSInterfaceOrientationMaskPortrait;
}

#pragma mark - WXApiDelegate
// 收到微信的回应
-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    
}

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:@"54b87c78fd98c5ca11000876" reportPolicy:(ReportPolicy) REALTIME channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    MyLog(@"online config has fininshed and note = %@", note.userInfo);
}


-(void)loadSevice{
    //----- 在主线程队列负责UI显示，而不影响后台代理的数据处理
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"]!=nil&&[[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]==NO) {
            
            MainViewController *main=[[MainViewController alloc]init];
            self.window.rootViewController=main;
            
        }else if([[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"]!=nil&&[[NSUserDefaults standardUserDefaults] boolForKey:@"rememberPassword"]){
            
            LoginViewController *login=[[LoginViewController alloc]init];
            self.window.rootViewController=login;
            
        }else{
            
            LaunchViewController *main=[[LaunchViewController alloc]init];
            self.window.rootViewController=main;
            //检查网络状态
            [self checknetwork];
        }
        if (!self.window.isKeyWindow) {
            [self.window makeKeyAndVisible];
        }
    });
}


-(void)checknetwork{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reach=[Reachability reachabilityWithHostname:@"www.baidu.com"];
    [reach startNotifier];
}


- (void)reachabilityChanged:(NSNotification *)note{
    Reachability *curReach=[note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status=[curReach currentReachabilityStatus];
    if (status == NotReachable) {
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"亲,网络不给力喔~" leftButtonTitle:nil rightButtonTitle:@"看看去"];
        [alert show];
        alert.rightBlock = ^(){
            [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
        };
    } else {
        NSString *statusMessage = ([curReach currentReachabilityStatus] - 2) ? @"您已通过WiFi链接" : @"您已通过移动数据链接";
        DXAlertView * alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:statusMessage leftButtonTitle:nil rightButtonTitle:@"好"];
        [alert show];
        alert.rightBlock = ^(){
        };
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //断开链接
    [self disconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // 应用程序被激活后，直接连接，使用系统偏好中的保存的用户记录登录
    // 从而实现自动登录的效果！
    [self connect];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

    // 应用程序被激活后，直接连接，使用系统偏好中的保存的用户记录登录
    // 从而实现自动登录的效果！
    [self connect];
}

#pragma mark - XMPP相关方法
// 设置XMPPStream
- (void)setupStream
{
    // 0. 方法被调用时，要求_xmppStream必须为nil，否则通过断言提示程序员，并终止程序运行！
    NSAssert(_xmppStream == nil, @"XMPPStream被多次实例化！");
    
    // 1. 实例化XMPPSteam
    _xmppStream = [[XMPPStream alloc] init];
    
    // 让XMPP在真机运行时支持后台，在模拟器上是不支持后台服务运行的
#if !TARGET_IPHONE_SIMULATOR
    {
        // 允许XMPPStream在真机运行时，支持后台网络通讯！
        [_xmppStream setEnableBackgroundingOnSocket:YES];
    }
#endif
    
    // 2. 扩展模块
    // 2.1 重新连接模块
    _xmppReconnect = [[XMPPReconnect alloc] init];
    // 2.2 电子名片模块
    _xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _xmppvCardModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:_xmppvCardStorage];
    _xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_xmppvCardModule];
    
    // 2.4 花名册模块
    _xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterStorage];
    // 设置自动接收好友订阅请求
    [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:YES];
    // 自动从服务器更新好友记录，例如：好友自己更改了名片
    [_xmppRoster setAutoFetchRoster:YES];
    
    // 2.5 实体扩展模块
    _xmppCapabilitiesCoreDataStorage = [[XMPPCapabilitiesCoreDataStorage alloc] init];
    _xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:_xmppCapabilitiesCoreDataStorage];
    
    // 2.6 消息归档模块
    _xmppMessageArchivingCoreDataStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
    
    
    
    // 3. 将重新连接模块添加到XMPPStream
    [_xmppReconnect activate:_xmppStream];
    [_xmppvCardModule activate:_xmppStream];
    [_xmppvCardAvatarModule activate:_xmppStream];
    [_xmppRoster activate:_xmppStream];
    [_xmppCapabilities activate:_xmppStream];
    [_xmppMessageArchiving activate:_xmppStream];
    
    // 4. 添加代理
    // 由于所有网络请求都是做基于网络的数据处理，这些数据处理工作与界面UI无关。
    // 因此可以让代理方法在其他线城中运行，从而提高程序的运行性能，避免出现应用程序阻塞的情况
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    [_xmppRoster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}

// 通知服务器器用户上线
- (void)goOnline
{
    // 1. 实例化一个”展现“，上线的报告，默认类型为：available
    XMPPPresence *presence = [XMPPPresence presence];
    // 2. 发送Presence给服务器
    // 服务器知道“我”上线后，只需要通知我的好友，而无需通知我，因此，此方法没有回调
    [_xmppStream sendElement:presence];
}

// 通知服务器器用户下线
- (void)goOffline
{
    // 1. 实例化一个”展现“，下线的报告
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    // 2. 发送Presence给服务器，通知服务器客户端下线
    [_xmppStream sendElement:presence];
}

// 连接到服务器
- (void)connect
{
    // 1. 如果XMPPStream当前已经连接，直接返回
    if ([_xmppStream isConnected]) {
        return;
    }
    //    在C语言中if判断真假：非零即真，如果_xmppStream==nil下面这段代码，与上面的代码结果不同。
    //    if (![_xmppStream isDisconnected]) {
    //        return;
    //    }
    
    // 2. 指定用户名、主机（服务器），连接时不需要password
    NSString *hostName = kXMPPHostNameKey;
    NSString *userName = [[LoginUser sharedLoginUser] myJIDName];
    
    // 3. 设置XMPPStream的JID和主机
    [_xmppStream setMyJID:[XMPPJID jidWithString:userName]];
    [_xmppStream setHostName:hostName];
    
    // 4. 开始连接
    NSError *error = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
    
    // 提示：如果没有指定JID和hostName，才会出错，其他都不出错。
    if (error) {
        MyLog(@"连接请求发送出错 - %@", error.localizedDescription);
    } else {
        MyLog(@"连接请求发送成功！");
    }
}

#pragma mark 连接到服务器
- (void)connectWithCompletion:(CompletionBlock)completion failed:(CompletionBlock)faild
{
    // 1. 记录块代码
    _completionBlock = completion;
    _faildBlock = faild;
    
    // 2. 如果已经存在连接，先断开连接，然后再次连接
    if ([_xmppStream isConnected]) {
        [_xmppStream disconnect];
    }
    
    // 3. 连接到服务器
    [self connect];
}

// 与服务器断开连接
- (void)disconnect
{
    // 1. 通知服务器下线
    [self goOffline];
    // 2. XMPPStream断开连接
    [_xmppStream disconnect];
}


#pragma mark 连接完成（如果服务器地址不对，就不会调用此方法）
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    // 从系统偏好读取用户密码
    NSString *password = [[LoginUser sharedLoginUser] password];
    
    if (_isRegisterUser) {
        // 用户注册，发送注册请求
        [_xmppStream registerWithPassword:password error:nil];
    } else {
        // 用户登录，发送身份验证请求
        [_xmppStream authenticateWithPassword:password error:nil];
    }
}


#pragma mark 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    _isRegisterUser = NO;
    // 注册成功，直接发送验证身份请求，从而触发后续的操作
    [_xmppStream authenticateWithPassword:[LoginUser sharedLoginUser].password error:nil];
}


#pragma mark 注册失败(用户名已经存在)
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    _isRegisterUser = NO;
    if (_faildBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _faildBlock();
        });
    }
}


#pragma mark 身份验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    if (_completionBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock();
        });
    }
    
    // 通知服务器用户上线
    [self goOnline];
}


#pragma mark 密码错误，身份验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    if (_faildBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _faildBlock();
        });
    }
}


#pragma mark 用户展现变化
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    MyLog(@"接收到用户展现数据 - %@", presence);
    // 1. 判断接收到的presence类型是否为subscribe
    if ([presence.type isEqualToString:@"subscribe"]){
        // 2. 取出presence中的from的jid
        XMPPJID *from = [presence from];
        MyLog(@"%@from from",from);
        // 3. 接受来自from添加好友的订阅请求
        [_xmppRoster acceptPresenceSubscriptionRequestFrom:from andAddToRoster:YES];
    }else if ([presence.type isEqualToString:@"do not disturb"]){
        
    }else if ([presence.type isEqualToString:@"away"]){
        
    }else if ([presence.type isEqualToString:@"avaliable"]){
        
    }
}


#pragma mark 判断IQ是否为SI请求
- (BOOL)isSIRequest:(XMPPIQ *)iq
{
    NSXMLElement *si = [iq elementForName:@"si" xmlns:@"http://jabber.org/protocol/si"];
    NSString *uuid = [[si attributeForName:@"id"]stringValue];
    
    if(si &&uuid ){
        return YES;
    }
    
    return NO;
}


#pragma mark 接收请求
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    MyLog(@"接收到请求 - %@", iq);
    
    // 0. 判断IQ是否为SI请求
    if ([self isSIRequest:iq]) {
        TURNSocket *socket = [[TURNSocket alloc] initWithStream:_xmppStream toJID:iq.to];
        
        [_socketList addObject:socket];
        
        [socket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    } else if ([TURNSocket isNewStartTURNRequest:iq]) {
        // 1. 判断iq的类型是否为新的文件传输请求
        // 1) 实例化socket
        TURNSocket *socket = [[TURNSocket alloc] initWithStream:sender incomingTURNRequest:iq];
        
        // 2) 使用一个数组成员记录住所有传输文件使用的socket
        [_socketList addObject:socket];
        
        // 3）添加代理
        [socket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return YES;
}


#pragma mark 接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    MyLog(@"接收到用户消息 - %@", message);
    AudioServicesPlaySystemSound(1106);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    XMPPJID * jid=  (XMPPJID *)[message from];
    MyLog(@"接收到用户JID-  %@",[jid user]);
    dispatch_async(dispatch_get_main_queue(), ^{
        XMPPJID * jid=  (XMPPJID *)[message from];
        [LoginUser sharedLoginUser].messageNum++;
        
        if ([LoginUser sharedLoginUser].messageNum>0) {
            messageFlag.badgeValue=[NSString stringWithFormat:@"%d",[LoginUser sharedLoginUser].messageNum];
        }
        else if([LoginUser sharedLoginUser].messageNum>=100)
            messageFlag.badgeValue=[NSString stringWithFormat:@"100+"];
        else
            messageFlag.badgeValue=nil;
        
        BOOL ff=NO;
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:[LoginUser sharedLoginUser].messageNumDic];
        
        for (NSString *mes in [dict allKeys]) {
            if ([mes isEqualToString:[jid user]]) {
                ff=YES;
                break;
            }
        }
        if (ff) {
            int num=[[dict valueForKey:[jid user]] intValue];
            num ++;
            [dict removeObjectForKey:[jid user]];
            [dict setObject:@(num) forKey:[jid user]];
        }
        else
        {
            [dict setObject:@(1) forKey:[jid user]];
        }
        [LoginUser sharedLoginUser].messageNumDic=dict;
    [[NSNotificationCenter defaultCenter]postNotificationName:KNoticationCenter object:[jid user]];
    });
    
    // 1. 针对图像数据单独处理，取出数据
    NSString *imageStr = [[message elementForName:@"imageData"] stringValue];
    
    if (imageStr) {
        // 2. 解码成图像
        NSData *data = [[NSData alloc] initWithBase64EncodedString:imageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        // 3. 保存图像
        UIImage *image = [UIImage imageWithData:data];
        // 4. 将图像保存到相册
        // 1) target 通常用self
        // 2) 保存完图像调用的方法
        // 3) 上下文信息
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    
}


#pragma mark - XMPPRoster代理
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    MyLog(@"接收到其他用户的请求 %@", presence);
}


#pragma mark - TURNSocket代理
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    MyLog(@"成功");
    
    // 保存或者发送文件
    // 写数据方法，向其他客户端发送文件
    //    socket writeData:<#(NSData *)#> withTimeout:<#(NSTimeInterval)#> tag:<#(long)#>
    // 读数据方法，接收来自其他客户端的文件
    //    socket readDataToData:<#(NSData *)#> withTimeout:<#(NSTimeInterval)#> tag:<#(long)#>
    
    // 读写操作完成之后断开网络连接
    [socket disconnectAfterReadingAndWriting];
    
    [_socketList removeObject:sender];
}


- (void)turnSocketDidFail:(TURNSocket *)sender
{
    MyLog(@"失败");
    
    [_socketList removeObject:sender];
}


-(void)logout{
    [self disconnect];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    MyLog(@"---Token--%@", deviceToken);
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示通知" message:token delegate:self cancelButtonTitle:@"取消通知" otherButtonTitles:@"确定通知", nil];
    [alert show];
    
    if (token.length == 0) {
        return;
    }
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    token = [token stringByTrimmingCharactersInSet:set];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    MyLog(@"~~~~token : %@",token);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    MyLog(@"userInfo == %@",userInfo);
    application.applicationIconBadgeNumber =2;
    NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示通知" message:message delegate:self cancelButtonTitle:@"取消通知" otherButtonTitles:@"确定通知", nil];
    [alert show];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    MyLog(@"Regist fail%@",error.localizedDescription);
}

@end
