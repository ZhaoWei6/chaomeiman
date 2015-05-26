
//  0.获取设备宽高
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth  [UIScreen mainScreen].bounds.size.width

//  1.判断是否为iOS8
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0 )
//  2.获得RGB颜色
#define XMColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//  3.全局背景色
#define XMGlobalBg XMColor(245, 245, 245)//视图背景色
#define XMButtonBg XMColor(89, 122, 155)//导航、按钮背景色

#define kTextFontColor333 XMColor(51, 51, 51)
#define kTextFontColor666 XMColor(102, 102, 102)
#define kTextFontColor999 XMColor(153, 153, 153)

#define kBorderColor XMColor(204, 204, 204)//边框颜色
//  4.自定义Log
#ifdef DEBUG
#define XMLog(...) NSLog(__VA_ARGS__)
#else
#define XMLog(...)
#endif

//  5.设置返回按钮标题为空
#define kNAVITAIONBACKBUTTON if(iOS7|iOS8){UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];\
temporaryBarButtonItem.title = @"";\
self.navigationItem.backBarButtonItem = temporaryBarButtonItem;}

//  6.
//  版本为iOS7及以上时，设置视图不允许穿透
#define kRectEdge 
//  显示隐藏底部分栏
#define kShowOrHiddenTabBar(show) XMMainViewController *mainVC = (XMMainViewController *)self.tabBarController;\
[mainVC showOrHiddenTabBarView:show];

//  7.轮播图
#define kPhotoNumber 3
#define kHomeHeadViewHeight 150
//  8.
//  网络状态改变
#define kNetWorkStateChange @"netWorkStateChange"
//  网络请求异常的通知
#define kNetWorkAnomalies @"netWorkAnomalies"
//  分类改变的通知
#define kCategoryChangeNote @"category_change"
//  排序改变的通知
#define kOrderChangeNote @"order_change"
//  退出系统的通知
#define kExitSystemNote @"exitSystem"
//  登陆系统成功的通知
#define kLoginSuccessNote @"loginSystem"
//  接收通知
#define kAddAllNotes(method) \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(method) name:kCategoryChangeNote object:nil]; \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(method) name:kOrderChangeNote object:nil];
//   订单评价成功的通知
#define kOrderStateChange @"order_change"
//  需求确定
#define kServicesChangeNote @"services_change"
//  联系人确定
#define kContactsChangeNote @"contacts_change"
//  判断并未进店是否隐藏


//默认数据库
#define UserDefaults            [NSUserDefaults standardUserDefaults]
//版本号
#define oyxc_version            @"version"//version
#define AppVersion          [[NSBundle mainBundle] objectForInfoDictionaryKey:CFBridgingRelease(kCFBundleVersionKey)]
//是否强制更新
#define oyxc_isUpdata            @"isUpdata"//isUpdata

#define BaseUrl @"http://123.57.35.205:8866/index.php/mobile/"   //外网

