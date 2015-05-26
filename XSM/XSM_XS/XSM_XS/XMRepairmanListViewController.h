//
//  XMRepairmanListViewController.h
//  XSM_XS
//
//  Created by Apple on 14/11/27.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@class ReorderItem;
@interface XMRepairmanListViewController : XMBaseViewController<MAMapViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet ReorderItem *orderItem0;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic , assign) int itemcategory;//商品分类id =2iPhone，=3小米
@property (nonatomic , assign) int orderby;//排序  0离我最近 1修理最多 2评价最高

- (IBAction)changeOrder:(ReorderItem *)sender;


@end
