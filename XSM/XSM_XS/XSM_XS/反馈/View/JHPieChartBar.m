//
//  JHPieChartBar.m
//  XSM_XS
//
//  Created by Andy on 15/1/7.
//  Copyright (c) 2015年 xiushenma. All rights reserved.
//

#define JHColorBlue [UIColor colorWithRed:0.0 green:153/255.0 blue:204/255.0 alpha:1.0]
#define JHColorGreen [UIColor colorWithRed:153/255.0 green:204/255.0 blue:51/255.0 alpha:1.0]
#define JHColorOrange [UIColor colorWithRed:1.0 green:153/255.0 blue:51/255.0 alpha:1.0]
#define JHColorRed [UIColor colorWithRed:1.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define JHColorYellow [UIColor colorWithRed:1.0 green:220/255.0 blue:0.0 alpha:1.0]
#define JHColorDefault [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]

#import "JHPieChartBar.h"
#import "WBProgressPieView.h"
#import "XMCommon.h"

@interface JHPieChartBar()

@property (nonatomic, strong) NSArray *colorArray;


@end

@implementation JHPieChartBar

+ (instancetype)pieChartBarWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame
{
    return [[JHPieChartBar alloc] initWithArray:array title:title frame:frame];
}

- (instancetype)initWithArray:(NSArray *)array title:(NSString *)title frame:(CGRect)frame
{
    self = [[JHPieChartBar alloc] init];
    [self setFrame:frame];
    [self setBackgroundColor:[UIColor colorWithRed:40/255.0 green:69/255.0 blue:99/255.0 alpha:1]];

    // 添加标题
    UILabel *barTitleLabel = [self addLabelWithTitle:title];
    CGFloat title_x = 0;
    CGFloat title_w = self.frame.size.width - 2 * title_x;
    [barTitleLabel setFrame:CGRectMake(title_x, 15, title_w, 30)];
    [self addSubview:barTitleLabel];
    
    // 内容
    [self setupPieContentViewWith:array];
    
    // 标签
    
    return self;
}

- (void)setupPieContentViewWith:(NSArray *)array
{
    
    if (self) {
        
         // 饼状图
        CGFloat width = self.frame.size.width;
        NSMutableArray *values = [NSMutableArray array];
        for (int index = 0; index < array.count; ++index) {
            NSDictionary *dict = array[index];
            int count = [dict[@"count"] intValue];
            NSNumber *number = [NSNumber numberWithInt:count];
            [values addObject:number];
        }
        
        NSArray *colors = [NSMutableArray arrayWithObjects: JHColorBlue, JHColorGreen, JHColorOrange, JHColorRed, JHColorYellow, nil];
        self.colorArray = colors;
        CGFloat outerRadius = width * 0.33;
        CGFloat innerRadius = width * 0.18;
        
        WBProgressPieView *pieChart = [WBProgressPieView progressPieViewWithValueArray:values colorArray:colors innerRadius:innerRadius outerRadius:outerRadius startingAngle:4.0 innerCircleColor: [UIColor colorWithRed:40/255.0 green:69/255.0 blue:99/255.0 alpha:1]];
        CGFloat pieChart_x = self.center.x - outerRadius;
        pieChart.frame = CGRectMake(pieChart_x, self.frame.size.height * 0.18, 0, 0);
        
        [self addSubview:pieChart];
        
        float info_y = CGRectGetMaxY(pieChart.frame) + 10;
        
        // 信息
        [self showPieChartInfoWithArray:array yVlaue:info_y];
    }

}

- (void)showPieChartInfoWithArray:(NSArray *)array yVlaue:(CGFloat)y
{
    // 计算占有率
    float allCount = 0;
    for (int index = 0; index < array.count; ++index) {
        
        NSDictionary *dict = array[index];
        float count = [dict[@"count"] floatValue];
        allCount = allCount +count;

    }
    
    NSMutableArray *coutArray = [NSMutableArray array];
    for (int index = 0; index <array.count; ++index) {
        
        NSDictionary *dict = array[index];
        float count = [dict[@"count"] floatValue];
        float parent = 100 * (count/allCount);
        NSString *parentNum = [NSString stringWithFormat:@"%.0f%%", parent];
        [coutArray addObject:parentNum];
        
    }
    
    CGFloat width = self.frame.size.width;
    CGFloat view_x = self.center.x - width * 0.37;
    CGFloat view_h = 20;
    CGFloat intervel = 1;
    
    for (int index = 0; index < array.count; ++index) {
        
        UIColor *color = self.colorArray[index];
        NSDictionary *dict = array[index];
        CGFloat view_y = y + (view_h +intervel) * index;
        
        UIView *colorView = [[UIView alloc] init];
        [colorView setBackgroundColor:color];
        [colorView setFrame:CGRectMake(view_x, view_y, 5, view_h)];
        [self addSubview:colorView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
        [titleLabel setFrame:CGRectMake(view_x + 5, view_y, width * 0.54, view_h)];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:dict[@"appupdatelog"]];
        [self addSubview:titleLabel];
        
        UILabel *valueLabel = [[UILabel alloc] init];
        [valueLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
        [valueLabel setFrame:CGRectMake(view_x + 5 + width * 0.54 + intervel, view_y, width * 0.18, view_h)];
        [valueLabel setFont:[UIFont systemFontOfSize:13]];
        [valueLabel setTextAlignment:NSTextAlignmentCenter];
        [valueLabel setTextColor:[UIColor whiteColor]];
        [valueLabel setText:[NSString stringWithFormat:@"%@", coutArray[index]]];
        [self addSubview:valueLabel];
        
    }
    
}

- (UILabel *)addLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:19]];
    [label setTextColor:[UIColor whiteColor]];
    
    return label;
}

@end
