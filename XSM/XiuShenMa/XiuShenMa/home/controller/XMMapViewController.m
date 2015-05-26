//
//  XMMapViewController.m
//  XiuShemMa
//
//  Created by Apple on 14-10-5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMapViewController.h"
#import "XMBasicMapAnnotation.h"
#import "XMCustomMapAnnotaion.h"

#import "XMCustomAnnotationView.h"
#import "XMCustomMapCell.h"

#import "XMBaseNavigationController.h"
#import "XMRepairDetailViewController.h"

#import "XMMetaDataTool.h"
#import "XMRepairman.h"
#import "XMDealTool.h"
#import "XMMap.h"
#define kSpan MACoordinateSpanMake(0.018404, 0.031468)
#define span 40000
@interface XMMapViewController ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) XMCustomAnnotationView *calloutAnnotation;

@end

@implementation XMMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMapView];
    
    [self initButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    for (id <MAAnnotation>annotation in _mapView.selectedAnnotations) {
        [_mapView deselectAnnotation:annotation animated:YES];
    }
}

- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = @"fa1d05282382b78d61e0ed999496de73";
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
    self.mapView.showsUserLocation = YES;
}

- (void)initButton
{
    //返回用户位置
    UIButton *backUser = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"icon_map_location"];
    [backUser setBackgroundImage:image forState:UIControlStateNormal];
    backUser.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    backUser.frame = CGRectMake(10, kDeviceHeight-kUIButtonHeight-10, kUIButtonHeight, kUIButtonHeight);
    backUser.layer.cornerRadius = kUIButtonHeight/2;
    backUser.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [backUser addTarget:self action:@selector(backUserClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backUser];
    
    //返回前一页
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, kUIButtonHeight, kUIButtonHeight);
    backButton.layer.cornerRadius = kUIButtonHeight/2;
    backButton.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage resizedImage:@"icon_back"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor blackColor];
    backButton.alpha = 0.6;
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:backButton];
}

#pragma mark delegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    self.mapView.showsUserLocation = NO;
//    if (_mapView) return;
    // 1.位置（中心点）
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    // 2.跨度（范围）
    MACoordinateRegion region = MACoordinateRegionMake(center, kSpan);
    // 3.区域
    [mapView setRegion:region animated:YES];
    
    [[XMDealTool sharedXMDealTool] repairmansFromUserAddressSuccess:^(NSArray *deals, int islast) {
        XMLog(@"修神坐标点：%@",deals);
        for (XMMap *d in deals) {
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(d.latitude, d.longitude);
            XMBasicMapAnnotation *anno = [[XMBasicMapAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
            anno.anno = d;
            anno.title = @"修神";
            [mapView addAnnotation:anno];
        }
    }];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[XMBasicMapAnnotation class]]) {
        XMBasicMapAnnotation *anno = annotation;
//        XMCustomAnnotationView *annotationView = (XMCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:nil];
//        if (!annotationView) {
            XMCustomAnnotationView *annotationView = [[XMCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
            XMCustomMapCell  *cell = [[XMCustomMapCell alloc] init];
            cell.map = anno.anno;
            cell.tag = 101;
            cell.frame = CGRectMake(0, 0,120,60);
            [annotationView.contentView addSubview:cell];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = cell.bounds;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(clickMapCell:) forControlEvents:UIControlEventTouchUpInside];
            [annotationView.contentView addSubview:button];
            
            
            annotationView.maintainer_id = anno.anno.maintainer_id;
//        }
        return annotationView;
    }
    return nil;
}

#pragma mark - 点击大头针跳转至店铺详情
- (void)clickMapCell:(UIButton *)sender

{
    XMCustomMapCell *cell = (XMCustomMapCell *)[[sender superview] viewWithTag:101];
    XMMap *ann = cell.map;
    XMLog(@"您点击了大头针   修神id-->%@",ann.maintainer_id);
    XMRepairDetailViewController *detail = [[XMRepairDetailViewController alloc] init];
    detail.maintainer_id = ann.maintainer_id;
    detail.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:detail action:@selector(backButtonClick)];
    [self presentViewController:[[XMBaseNavigationController alloc] initWithRootViewController:detail] animated:YES completion:^{}];
}


- (void)backUserClick
{
    // 1.位置（中心点）
    CLLocationCoordinate2D center = _mapView.userLocation.location.coordinate;
    // 2.跨度（范围）
    MACoordinateRegion region = MACoordinateRegionMake(center, kSpan);
    // 3.区域
    [_mapView setRegion:region animated:YES];
}

//返回按钮
- (void)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

@end
