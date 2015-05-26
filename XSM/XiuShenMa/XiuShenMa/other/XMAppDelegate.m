//
//  XMAppDelegate.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMAppDelegate.h"
#import "XMMainViewController.h"
#import "SDImageCache.h"

#import "XMDealTool.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "XMBaseViewController.h"
#import "XMOrderStateDetailController.h"
#import "XMBaseNavigationController.h"
@implementation XMAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (XMAppDelegate *)shareApp
{
    return (XMAppDelegate *)[UIApplication sharedApplication].delegate;
}
#pragma mark - 网络连接判断
- (void)reachabilityChanged:(NSNotification *)note {
    
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        [MBProgressHUD showError:@"无网络连接"];
    }
}
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    //
    _modalAnimationController = [[ModalAnimation alloc] init];
    
    //保存用户名密码
    if ([UserDefaults objectForKey:@"userid"]&&[UserDefaults objectForKey:@"password"]) {
        flag = YES;
        phone_Number = [UserDefaults objectForKey:@"phone"];
        [XMDealTool sharedXMDealTool].userid = [UserDefaults objectForKey:@"userid"];
        [XMDealTool sharedXMDealTool].password = [UserDefaults objectForKey:@"password"];
        [self setUserAliasWithUserid:[XMDealTool sharedXMDealTool].userid];
    }
    /*
    else{
        [UserDefaults setObject:@"13601247906" forKey:@"userid"];
        [UserDefaults setObject:@"123123" forKey:@"password"];
        flag = YES;
    }
    */
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearMemory];
    
    //设置可用内存范围
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
    sharedCache = nil;
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.google.com"];
    [hostReach startNotifier];

    // 分享
    [self initSocial];
    
    self.window.rootViewController = [[XMMainViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    //推送通知
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //
    NSDictionary* pushInfo = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (pushInfo)
    {
        NSDictionary *apsInfo = [pushInfo objectForKey:@"aps"];
        if(apsInfo)
        {
            [self pushToJump:launchOptions withFirstStart:YES];
        }
    }
    
    
    
    //判断用户是不是第一次启动程序
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    } 
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    
    
    return YES;
}

#pragma mark - 分享
- (void)initSocial
{
    //设置友盟AppKey
    [UMSocialData setAppKey:@"54680edefd98c5e1160084a0"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx1d126eb553da4ef3" appSecret:@"741ffa1449429a584e7a52caf48f68b9" url:@"http://app.xiushenma.com/share/"];
    //设置点击分享内容跳转链接
    //    [UMSocialData defaultData].extConfig.wxMessageType =
    //1.微信
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"四个人有三个人用TA";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://app.xiushenma.com/share/";
    //2.微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"四个人有三个人用TA";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://app.xiushenma.com/share/";
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"1103494171" appKey:@"x1BarYSUUHvrhe8k" url:@"http://app.xiushenma.com/share/"];
    //设置点击分享内容跳转链接
    //1.QQ
    [UMSocialData defaultData].extConfig.qqData.title = @"四个人有三个人用TA";
    [UMSocialData defaultData].extConfig.qqData.url = @"http://app.xiushenma.com/share/";
    //2.Qzone
    [UMSocialData defaultData].extConfig.qzoneData.title = @"四个人有三个人用TA";
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

#pragma mark - 页面跳转
- (void)pushToJump:(NSDictionary*)userInfo withFirstStart:(BOOL)firstStart
{
    XMOrderStateDetailController *orderVC = [[XMOrderStateDetailController alloc] init];
    orderVC.orderID = userInfo[@"order_id"];
    
    [self.window.rootViewController.childViewControllers[0] pushViewController:orderVC animated:YES];
}
#pragma mark - 为用户设置别名
- (void)setUserAliasWithUserid:(NSString *)userid
{
    [APService setAlias:userid callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
#pragma mark - JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"this is iOS7 Remote Notification%@",userInfo);
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
    }else{
        NSDictionary *aps = [userInfo valueForKey:@"aps"];
        if (aps) {
            [self pushToJump:userInfo withFirstStart:YES];
        }
    }
    
    UITabBarController *tabbarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabbarController.tabBar;
    UITabBarItem *orderItem = [tabBar.items objectAtIndex:1];
    orderItem.badgeValue = @"新";
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    XMLog(@"点击了按钮%li",(long)buttonIndex);
    NSString *message = alertView.message;
    NSDictionary *aps = @{@"alert":message};
    if (aps) {
        [self pushToJump:aps withFirstStart:YES];
    }
}
#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}

#pragma mark -
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSString *msg = @"暂无最新版本";
    NSString * appNew = [UserDefaults objectForKey:oyxc_version];
    NSString *versionNew = [appNew stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *versionOld = [AppVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    for (int i = 0; i < 3-versionNew.length; ++i) {
        versionNew = [versionNew stringByAppendingString:@"0"];
    }
    for (int i = 0; i < 3-versionOld.length; ++i) {
        versionOld = [versionOld stringByAppendingString:@"0"];
    }
    
    if (versionNew.integerValue > versionOld.integerValue) {
        if ([UserDefaults boolForKey:oyxc_isUpdata]) {
            msg = [NSString stringWithFormat:@"检测到最新版本%@",appNew];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"去下载", nil];
            alert.tag = 2;
            [alert show];
            
        }
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 2) {
//        
////        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[UserDefaults objectForKey:oyxc_downUrl]]];
//        
//    }
//}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
#pragma mark -
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            XMLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XiuShemMa" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XiuShemMa.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        XMLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
