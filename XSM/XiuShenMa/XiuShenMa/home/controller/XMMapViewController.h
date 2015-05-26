//
//  XMMapViewController.h
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "XMMap.h"

@interface XMMapViewController : XMBaseViewController<MAMapViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property(nonatomic,retain)XMMap  *map;

@end
