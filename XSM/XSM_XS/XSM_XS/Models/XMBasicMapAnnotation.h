//
//  XMAnnotation.h
//  XiuShemMa
//
//  Created by Apple on 14-10-6.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import "XMMap.h"
@interface XMBasicMapAnnotation : NSObject <MAAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int maintainer_id;
@property (nonatomic, retain) XMMap *anno;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
