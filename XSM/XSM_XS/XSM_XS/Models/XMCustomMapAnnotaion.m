//
//  XMCustomMapAnnotaion.m
//  XiuShemMa
//
//  Created by Apple on 14-10-16.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMCustomMapAnnotaion.h"

@implementation XMCustomMapAnnotaion

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
            addContent:(NSDictionary*)content{
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.content = content;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}

@end
