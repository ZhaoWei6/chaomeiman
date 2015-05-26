//
//  GeoViewController.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "GeoViewController.h"
#import "GeoDetailViewController.h"
#import "CommonUtility.h"
#import "GeocodeAnnotation.h"

#define GeoPlaceHolder @"名称"

@interface GeoViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *displayController;

@property (nonatomic, strong) NSMutableArray *tips;

@end

@implementation GeoViewController
@synthesize tips = _tips;
@synthesize searchBar = _searchBar;
@synthesize displayController = _displayController;

#pragma mark - Utility

/* 地理编码 搜索. */
- (void)searchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = key;
    
    if (adcode.length > 0)
    {
        geo.city = @[adcode];
    }
    
    [self.search AMapGeocodeSearch:geo];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    [self.search AMapInputTipsSearch:tips];
}

/* 清除annotation. */
- (void)clear
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)clearAndSearchGeocodeWithKey:(NSString *)key adcode:(NSString *)adcode
{
    /* 清除annotation. */
    [self clear];
    
    [self searchGeocodeWithKey:key adcode:adcode];
}

- (void)gotoDetailForGeocode:(AMapGeocode *)geocode
{
    if (geocode != nil)
    {
        NSLog(@"当前地址:%@  %@",geocode.formattedAddress,geocode.location);
//        GeoDetailViewController *geoDetailViewController = [[GeoDetailViewController alloc] init];
//        geoDetailViewController.geocode = geocode;
//        
//        [self.navigationController pushViewController:geoDetailViewController animated:YES];
        if ([_delegate respondsToSelector:@selector(setAddressWithGeocode:)]) {
            [_delegate setAddressWithGeocode:geocode];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
    }
}

- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GeocodeAnnotation class]] )
    {
        if ([(GeocodeAnnotation*)view.annotation geocode]) {
            [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
        }
    }
}

//- (void)clickAnnotation
//{
//    MAAnnotationView *view = [self.mapView selectedAnnotations][0];
//    if (view) {
//        [self gotoDetailForGeocode:[(GeocodeAnnotation*)view.annotation geocode]];
//    }else{
//        [[[UIAlertView alloc] initWithTitle:@"提示"
//                                   message:@"您未选中任何地点"
//                                  delegate:nil
//                         cancelButtonTitle:nil
//                         otherButtonTitles:@"继续", nil] show];
//    }
//}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]])
    {
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:geoCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
//        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return poiAnnotationView;
    }
    return nil;
}

#pragma mark - AMapSearchDelegate

/* 地理编码回调.*/
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count == 0)
    {
        return;
    }
    
    NSMutableArray *annotations = [NSMutableArray array];
    
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *obj, NSUInteger idx, BOOL *stop) {
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:obj];
        
        [annotations addObject:geocodeAnnotation];
    }];
    
    if (annotations.count == 1)
    {
        [self.mapView setCenterCoordinate:[annotations[0] coordinate] animated:YES];
    }
    else
    {
        [self.mapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:annotations]
                               animated:YES];
    }
    
    [self.mapView addAnnotations:annotations];
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    [self.tips setArray:response.tips];
    
//    NSLog(@"%@",response);
    
    [self.displayController.searchResultsTableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.searchResultsButtonSelected) {
        searchBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    }else{
        searchBar.frame = CGRectMake(0, 64, self.view.frame.size.width, 44);
    }
//    return NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *key = searchBar.text;
    
    [self clearAndSearchGeocodeWithKey:key adcode:nil];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = key;
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self searchTipsWithKey:searchString];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.adcode;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapTip *tip = self.tips[indexPath.row];
    
    [self clearAndSearchGeocodeWithKey:tip.name adcode:tip.adcode];
    
    [self.displayController setActive:NO animated:NO];
    
    self.searchBar.placeholder = tip.name;
}

#pragma mark - Initialization

- (void)initSearchBar
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
    self.searchBar.barStyle     = UIBarStyleDefault;
    self.searchBar.translucent  = YES;
	self.searchBar.delegate     = self;
    self.searchBar.placeholder  = GeoPlaceHolder;
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    
    [self.view addSubview:self.searchBar];
//    self.navigationItem.titleView = self.searchBar;
}

- (void)initSearchDisplay
{
    self.displayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.displayController.delegate                = self;
    self.displayController.searchResultsDataSource = self;
    self.displayController.searchResultsDelegate   = self;
}

- (void)initBaseNavigationBar
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickAnnotation)];
}

- (void)initUserLocation
{
    self.mapView.showsUserLocation = YES;
    
    //长按屏幕，添加大头针
    UILongPressGestureRecognizer *Lpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(LongPressClick:)];
    Lpress.delegate = self;
    Lpress.minimumPressDuration = 1.0;//1.0秒响应方法
    Lpress.allowableMovement = 50.0;
    [self.mapView addGestureRecognizer:Lpress];
}
//手势响应事件
-(void)LongPressClick:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    //坐标转换
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
{
    self.mapView.showsUserLocation = NO;
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeoRequest];
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        AMapGeocode *geocode = [[AMapGeocode alloc] init];
        geocode.location = request.location;
        geocode.formattedAddress = response.regeocode.formattedAddress;
        GeocodeAnnotation *geo = [[GeocodeAnnotation alloc] initWithGeocode:geocode];
        [self.mapView addAnnotation:geo];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - Life Cycle

- (id)init
{
    if (self = [super init])
    {
        self.tips = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"当前位置";
    
    [self initSearchBar];
    
    [self initSearchDisplay];
    
    [self initBaseNavigationBar];
    
    [self initUserLocation];
}

@end
