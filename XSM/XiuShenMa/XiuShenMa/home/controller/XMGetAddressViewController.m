//
//  XMGetAddressViewController.m
//  XiuShenMa
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMGetAddressViewController.h"
#import "XMAddressAnnotation.h"
@interface XMGetAddressViewController ()

@end

@implementation XMGetAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要进店";
    
    [self initMapView];
    [self addDefaultAnnotation];
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 16.1;
}

- (void)addDefaultAnnotation
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.coordinate;
    startAnnotation.title      = @"长按地址拷贝：";
    
    [self.mapView addAnnotation:startAnnotation];
    self.mapView.centerCoordinate = self.coordinate;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        XMAddressAnnotation *annotationView = (XMAddressAnnotation *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView) {
            annotationView = [[XMAddressAnnotation alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            
            UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, annotationView.width, 20)];
            labelTop.text = @"长按下方地址拷贝:";
            [annotationView.contentView addSubview:labelTop];
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, 20, annotationView.width, 1)];
            sep.backgroundColor = kBorderColor;
            [annotationView.contentView addSubview:sep];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, annotationView.width, 41)];
            label.text = self.address;
            label.numberOfLines = 2;
            label.textColor = kTextFontColor666;
            [annotationView.contentView addSubview:label];
            
            label.userInteractionEnabled = YES;
            [label addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickAnnotaion:)]];
        }
        return annotationView;
    }
    
    return nil;
}
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    XMLog(@"长按了大头针");
}
- (void)clickAnnotaion:(UILongPressGestureRecognizer *)sender
{
    UIPasteboard *generalPasteBoard = [UIPasteboard generalPasteboard];
    
    [generalPasteBoard setString:self.address];
    XMLog(@"长按了大头针");
    [MBProgressHUD showSuccess:@"已拷贝至剪切板"];
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
