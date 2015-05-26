//
//  XMMapViewController.m
//  XSM_XS
//
//  Created by Apple on 14/12/5.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMMapViewController.h"
#import "XMDealTool.h"
#import "XMMap.h"
#import "Measurement.h"

#import "XMBasicMapAnnotation.h"
#import "XMCustomMapAnnotaion.h"
#import "XMCustomAnnotationView.h"
#import "XMCustomMapCell.h"
#import "XMShopDetailViewController.h"
#import "XMNavigationViewController.h"
@interface XMMapViewController ()

@end

@implementation XMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    [self.mapView setZoomLevel:16.1 animated:YES];

    
    //返回按钮
    [self initBackButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView deselectAnnotation:self.mapView.selectedAnnotations[0] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)initBackButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 20, 40, 40);
    backButton.layer.cornerRadius = 40/2;
    backButton.imageView.contentMode = UIViewContentModeCenter && UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor blackColor];
    backButton.alpha = 0.6;
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.view addSubview:backButton];
    [self.view bringSubviewToFront:backButton];
}
#pragma mark - 获取当前位置信息
- (void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.mapView.showsUserLocation = NO;
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self clear];
        [[XMDealTool sharedXMDealTool] repairmansFromUserAddressSuccess:^(NSArray *deals, int islast) {
            NSLog(@"修神坐标点：%@",deals);
            for (XMMap *d in deals) {
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(d.latitude, d.longitude);
                XMBasicMapAnnotation *anno = [[XMBasicMapAnnotation alloc] initWithLatitude:coordinate.latitude andLongitude:coordinate.longitude];
                anno.anno = d;
                anno.title = @"修神";
                [mapView addAnnotation:anno];
            }
        }];
    }
}
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[XMBasicMapAnnotation class]]) {
        XMBasicMapAnnotation *anno = annotation;
        XMCustomAnnotationView *annotationView = (XMCustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[XMCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            XMCustomMapCell  *cell = [[XMCustomMapCell alloc] init];
            cell.map = anno.anno;
            cell.tag = 101;
            cell.frame = CGRectMake(0, 0,120,60);
            
            
            cell.backgroundColor = [UIColor clearColor];
            [annotationView.contentView addSubview:cell];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = cell.bounds;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(clickMapCell:) forControlEvents:UIControlEventTouchUpInside];
            [annotationView.contentView addSubview:button];
            
            
            annotationView.maintainer_id = anno.anno.maintainer_id;
        }
        
        
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

//    if ([view isKindOfClass:[CustomAnnotationView class]]) {
//        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
//        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:self.mapView];
//        
//        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
//        
//        if (!CGRectContainsRect(self.mapView.frame, frame))
//        {
//            /* Calculate the offset to make the callout view show up. */
//            CGSize offset = [self offsetToContainRect:frame inRect:self.mapView.frame];
//            
//            CGPoint theCenter = self.mapView.center;
//            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
//            
//            CLLocationCoordinate2D coordinate = [self.mapView convertPoint:theCenter toCoordinateFromView:self.mapView];
//            
//            [self.mapView setCenterCoordinate:coordinate animated:YES];
//        }
//        
//    }


    
    XMShopDetailViewController *detail = [[XMShopDetailViewController alloc] init];
    detail.maintainer_id = ann.maintainer_id;
    [UIApplication sharedApplication].statusBarHidden = NO;
    detail.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:detail action:@selector(backButtonClick)];
    [self presentViewController:[[XMNavigationViewController alloc] initWithRootViewController:detail] animated:YES completion:^{
        
    }];
}
#pragma mark - 返回



- (void)backButtonClick
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
