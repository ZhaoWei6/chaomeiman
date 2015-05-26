//
//  ExpertActive.h
//  超健康
//
//  Created by mac on 15-1-20.
//  Copyright (c) 2015年 ChaoMeiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpertActive : NSObject

@property(nonatomic,strong)NSString *AcContent;
@property(nonatomic,strong)NSString *AcDate;
@property(nonatomic,strong)NSString *AcImage;
@property(nonatomic,strong)NSString *AcId;

@property(nonatomic,strong)NSString *day;
@property(nonatomic,strong)NSString *month;

@property(nonatomic,strong)NSArray *imageArr;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
