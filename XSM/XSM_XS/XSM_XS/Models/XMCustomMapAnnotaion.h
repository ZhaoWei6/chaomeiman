//
//  XMCustomMapAnnotaion.h
//  XiuShemMa
//
//  Created by Apple on 14-10-16.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface XMCustomMapAnnotaion : NSObject<MKAnnotation>

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

@property (nonatomic , retain) NSDictionary *content;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
            addContent:(NSDictionary*)content;

@end
