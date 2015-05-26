//
//  XMGetAddressViewController.h
//  XiuShenMa
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface XMGetAddressViewController : XMBaseViewController<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;

/* 修神位置经纬度. */
@property (nonatomic) CLLocationCoordinate2D coordinate;
/* 修神位置 */
@property (nonatomic, copy) NSString *address;

@end
