

///
//
//

// 1.首页
// 轮播容器     高度
//#define kHomeHeadViewHeight kDeviceWidth*4/9

// 入口按钮     高度
#define kInfoButtonHeightStyle1 (kDeviceHeight-kHomeHeadViewHeight-21-64-49)/2
//#define kInfoButtonHeightStyle2 (kDeviceHeight-kHomeHeadViewHeight-kInfoButtonHeightStyle1-20-64-49)
// 入口按钮     宽度
#define kInfoButtonWidth (kDeviceWidth-21)/2
// 表视图       高度
#define kTableViewHeight kDeviceHeight - 64 - 49
// 首页轮播图片数量
#define kPhotoNumber 3

// 2.附近的修神界面
//  头部菜单
#define kRepairHeadViewHeight 74
//  字体格式
//(位置标签、单元格顶部标题、修神擅长描述、距离)
#define kRepairTextFont [UIFont systemFontOfSize:15]
//(修神姓名、已修数量、好评率)
#define kRepairTextFont1 [UIFont boldSystemFontOfSize:16]

// 3.修神详情界面
// 顶部照片墙高度
#define kDetailPhotoHeight 150
// 标签字体大小
#define kDetailLabelFont [UIFont systemFontOfSize:18]
//

//  4.订单首页
// 订单首页图片大小
#define kOrderImageWidth 138/2.0
#define kOrderImageHeight 168/2.0

//  5.订单详情
//  顶部图片的frame
#define kOrderDetailImageViewFrame CGRectMake(10, 10, 80, 80)
//  订单详情控制器中字体大小
#define kDetailFont [UIFont boldSystemFontOfSize:18];
//  订单信息标签
#define kOrderDetailLeftLabelWidth 120
#define kOrderDetailRightLabelWidth kDeviceWidth-20-kOrderDetailLeftLabelWidth
//
#define kOrderDetailLabelHeight 30

//  6.我的
//头部视图高度
#define kMineHeadViewHeight 130

//  7.地图
//  自定义大头针视图
#define kMapCellHeight 60
#define kMapCellWidth 120

//  表格段首高度
#define kHeaderViewHeight 45

//  8.预约上门
#define kOrderHomeServiceTopViewHeight 44

//
/**
 *  修改控件指定位置长度的字符串为特定的颜色
 *
 *  @param kLabel 要修改的标签
 *  @param kIndex 起始位置
 *  @param kStr   要修改的字符串
 *  @param kColor 要显示的颜色
 */
#define kColorText(kLabel,kIndex,kStr,kColor)\
{  NSMutableAttributedString *labelString =[[NSMutableAttributedString alloc]initWithString:kLabel.text];\
[labelString addAttribute:NSForegroundColorAttributeName value:kColor range:NSMakeRange(kIndex,[kStr length])];\
kLabel.attributedText = labelString;  }


//所有按钮高度
//#define kUIButtonHeight if(kDeviceWidth==320)44 else 50
//#ifdef kDeviceWidth==320
#define kUIButtonHeight 41
#define kUILoginHeight  50
//#else
//#define kUIButtonHeight 50
//#endif

