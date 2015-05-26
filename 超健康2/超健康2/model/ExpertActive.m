//
//  ExpertActive.m
//  超健康
//
//  Created by mac on 15-1-20.
//  Copyright (c) 2015年 ChaoMeiman. All rights reserved.
//

#import "ExpertActive.h"

@implementation ExpertActive
-(instancetype)initWithDictionary:(NSDictionary *)dict
{

    self.AcContent=[NSString stringWithFormat:@"%@",[dict valueForKey:@"dynamic_content"]];

    NSDictionary *time=[dict valueForKey:@"dynamic_create_date"];
    int year=[[time valueForKey:@"year"] intValue]+1900;
    int month=[[time valueForKey:@"month"] intValue]+1;
    int day=[[time valueForKey:@"date"] intValue];
    int hour=[[time valueForKey:@"hours"] intValue];
    int minute=[[time valueForKey:@"minutes"] intValue];
    int seconds=[[time valueForKey:@"seconds"] intValue];
    self.AcDate=[NSString stringWithFormat:@"%02d-%02d-%02d %02d:%02d:%02d",year,month,day,hour,minute,seconds];
    self.month=[self turnFrom:month];
    self.day=[NSString stringWithFormat:@"%02d",day];
    
    self.AcImage=[NSString stringWithFormat:@"%@",[dict valueForKey:@"dynamic_pic_url"]];
    self.AcId=[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    self.imageArr=[NSArray arrayWithArray:[dict valueForKey:@"pic_urlList"]];
    return self;
}
-(NSString *)turnFrom:(int)mm
{
    NSString *tMM;
    switch (mm) {
        case 1:
            tMM=@"一月";
            break;
        case 2:
            tMM=@"二月";
            break;
        case 3:
            tMM=@"三月";
            break;
        case 4:
            tMM=@"四月";
            break;
        case 5:
            tMM=@"五月";
            break;
        case 6:
            tMM=@"六月";
            break;
        case 7:
            tMM=@"七月";
            break;
        case 8:
            tMM=@"八月";
            break;
        case 9:
            tMM=@"九月";
            break;
        case 10:
            tMM=@"十月";
            break;
        case 11:
            tMM=@"十一月";
            break;
        case 12:
            tMM=@"十二月";
            break;
        default:
            break;
    }
    return tMM;
}
@end
