//
//  XMRepairmanViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
//#import <CoreLocation/CoreLocation.h>
//#import <MapKit/MapKit.h>

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@interface XMRepairmanViewController :  XMBaseViewController<MAMapViewDelegate,AMapSearchDelegate>

@property (nonatomic , assign) NSInteger     itemcategory;//商品分类id =2iPhone，=3小米
@property (nonatomic , assign) NSInteger     orderby;//排序  0离我最近 1修理最多 2评价最高
@property (nonatomic , copy  ) NSString      *address;//地址
@property (nonatomic , copy  ) NSString      *area;
@property (nonatomic , retain) MAMapView     *mapView;//地图   用于定位
@property (nonatomic , strong) AMapSearchAPI *search;//

@end
