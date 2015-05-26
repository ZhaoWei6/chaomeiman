//
//  AppDelegate.m
//  XSM_XS
//
//  Created by Apple on 14/11/26.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "AppDelegate.h"
#import "XMCommon.h"
#import "XMDealTool.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "APService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
#pragma mark - 网络连接判断
//- (void)reachabilityChanged:(NSNotification *)note {
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    NetworkStatus status = [curReach currentReachabilityStatus];
//    
//    if (status == NotReachable) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修神马"
//                                                        message:@"无网络连接"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //判断用户是不是第一次启动程序
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    // 1.设置分栏
    [self setTabbar];
    // 2.取出保存的用户名密码
    if ([UserDefaults objectForKey:@"userid"]&&[UserDefaults objectForKey:@"password"]&&[UserDefaults objectForKey:@"phone"]) {
        [XMDealTool sharedXMDealTool].userid = [UserDefaults objectForKey:@"userid"];
        [XMDealTool sharedXMDealTool].password = [UserDefaults objectForKey:@"password"];
        [XMDealTool sharedXMDealTool].phone = [UserDefaults objectForKey:@"phone"];
//        [self setUserAliasWithUserid:[XMDealTool sharedXMDealTool].userid];
        //为用户设置别名
        NSString *userid = [UserDefaults objectForKey:@"userid"];
        [APService setAlias:userid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }else{
        [UserDefaults setObject:@"0" forKey:@"approve"];
    }
    // 3.友盟分享
    [self initSocial];
    // 4.推送通知
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    // 清除Badge
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark - 设置底部分栏
- (void)setTabbar
{
    UITabBarController *tabbarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabbarController.tabBar;
    
    UITabBarItem *tabBarItem0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:4];
    
    
    [tabBarItem0 setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [tabBarItem0 setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [tabBarItem1 setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [tabBarItem1 setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [tabBarItem2 setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [tabBarItem2 setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [tabBarItem3 setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [tabBarItem3 setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    [tabBarItem4 setTitleTextAttributes:@{NSForegroundColorAttributeName : kTextFontColor666} forState:UIControlStateNormal];
    [tabBarItem4 setTitleTextAttributes:@{NSForegroundColorAttributeName : XMButtonBg} forState:UIControlStateSelected];
    
    tabBarItem0.selectedImage = [[UIImage imageNamed:@"home_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.image = [[UIImage imageNamed:@"home_home_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.title = @"首页";
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"home_order"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = [[UIImage imageNamed:@"home_order_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.title = @"订单";
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"home_shop"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = [[UIImage imageNamed:@"home_shop_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.title = @"店铺";
    
    tabBarItem3.selectedImage = [[UIImage imageNamed:@"home_four"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = [[UIImage imageNamed:@"home_four_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.title = @"反馈";
    
    tabBarItem4.selectedImage = [[UIImage imageNamed:@"home_my"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.image = [[UIImage imageNamed:@"home_my_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem4.title = @"我的";
    
    
}
#pragma mark - 分享
- (void)initSocial
{
    //设置友盟AppKey
    [UMSocialData setAppKey:@"54680edefd98c5e1160084a0"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx1d126eb553da4ef3" appSecret:@"741ffa1449429a584e7a52caf48f68b9" url:@"http://app.xiushenma.com/share/"];
    //设置点击分享内容跳转链接
    
    //1.微信
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"修神马，神马都修";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://app.xiushenma.com/share/";
    //2.微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"修神马，神马都修";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://app.xiushenma.com/share/";
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1103494171" appKey:@"x1BarYSUUHvrhe8k" url:@"http://app.xiushenma.com/share/"];
    //设置点击分享内容跳转链接
    //1.QQ
    [UMSocialData defaultData].extConfig.qqData.title = @"修神马，神马都修";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://app.xiushenma.com/share/";
    //2.Qzone
    [UMSocialData defaultData].extConfig.qzoneData.title = @"修神马，神马都修";
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://app.xiushenma.com/share/";
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
#pragma mark - 推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"this is iOS7 Remote Notification-->%@",userInfo);
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateActive ) {
        // 转换成一个本地通知，显示到通知栏
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.userInfo = userInfo;
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.alertBody = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        localNotification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kOrderStateChange object:nil];
    }
//    else{
//        NSDictionary *aps = [userInfo valueForKey:@"aps"];
//        if (aps) {
//            [self pushToJump:userInfo withFirstStart:YES];
//        }
//    }
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
    
    
    UITabBarController *tabbarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabbarController.tabBar;
    UITabBarItem *orderItem = [tabBar.items objectAtIndex:1];
    orderItem.badgeValue = @"新";
    
    
}

#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
