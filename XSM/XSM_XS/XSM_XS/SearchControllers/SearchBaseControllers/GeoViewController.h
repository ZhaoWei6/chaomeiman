//
//  GeoViewController.h
//  SearchV3Demo
//
//  Created by songjian on 13-8-14.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "BaseMapViewController.h"

@protocol SetAddressDelegate <NSObject>

- (void)setAddressWithGeocode:(AMapGeocode *)geocode;

@end

@interface GeoViewController : BaseMapViewController

@property (nonatomic , assign) id<SetAddressDelegate>delegate;

@end
