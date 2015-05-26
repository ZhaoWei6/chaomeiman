//
//  WBProgressPieView.m
//  WBProgressPieDemo
//
//  Created by luweibai on 14/12/15.
//  Copyright (c) 2014年 Weibai. All rights reserved.
//

#import "WBProgressPieView.h"

@interface WBProgressPieView()
@property (strong,nonatomic) NSArray *valueArray;
@property (strong,nonatomic) NSArray *colorArray;
@property (strong,nonatomic) NSMutableArray *angleArray;
@property (strong,nonatomic) NSMutableArray *shapeLayers;

@property (assign,nonatomic) CGFloat startingAngle;

@property (weak,nonatomic) UIView *circleView;


@end

@implementation WBProgressPieView
- (NSMutableArray *)angleArray
{
    if (_angleArray == nil) {
        _angleArray = [NSMutableArray array];
    }
    return _angleArray;
}
- (NSMutableArray *)shapeLayers
{
    if (_shapeLayers == nil) {
        _shapeLayers = [NSMutableArray array];
    }
    return _shapeLayers;
}

+ (instancetype)progressPieViewWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor:(UIColor *)innerColor
{
    WBProgressPieView *pieView = [[WBProgressPieView alloc] initWithValueArray:valueArray colorArray:colorArray innerRadius:innerRadius outerRadius:outerRadius startingAngle:startingAngle innerCircleColor:innerColor];
    
    return pieView;
}

- (instancetype)initWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor:(UIColor *)innerColor
{
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, outerRadius*2, outerRadius*2);
        self.valueArray = valueArray;
        self.colorArray = colorArray;
        self.startingAngle = startingAngle;
        [self drawPie];
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(outerRadius-innerRadius, outerRadius-innerRadius, innerRadius*2, innerRadius*2)];

        circleView.layer.cornerRadius =  innerRadius;
//        circleView.backgroundColor = [UIColor colorWithRed:36/255.0 green:57/255.0 blue:97/255.0 alpha:1];
        circleView.backgroundColor = innerColor;
        
        [self addSubview:circleView];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    //防止别人修改宽度
    frame.size.width = self.frame.size.width;
    
    frame.size.height = self.frame.size.height;
    
    [super setFrame:frame];
}


- (void)resetDataSetWithValueArray:(NSArray *)valueArray colorArray:(NSArray *)colorArray innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius startingAngle:(CGFloat)startingAngle innerCircleColor:(UIColor *)innerColor
{
    if (valueArray.count==colorArray.count && valueArray.count>0) {
        //清空之前的dataset
        self.valueArray = nil;
        self.colorArray = nil;

        //添加新的dataset
        self.valueArray = valueArray;
        self.colorArray = colorArray;
        self.startingAngle = startingAngle;
        self.bounds = CGRectMake(0, 0, outerRadius*2, outerRadius*2);
        
        [self drawPie];
    }
}

//画图方法
- (void)drawPie
{
    [self createDrawingLayers];
    
    [self calculateAngle];
    
    [self drawSlices];
}
//创建sliceLayer
- (void)createDrawingLayers
{
    //清空之前的sublayers
    for (CAShapeLayer *sublayer in self.shapeLayers) {
        [sublayer removeFromSuperlayer];
    }
    [self.shapeLayers removeAllObjects];

    //创建slices
    for (int i = 0; i < self.valueArray.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setStrokeColor:NULL];
        [shapeLayer setZPosition:0];
        //设置颜色
        [shapeLayer setFillColor:[[self.colorArray objectAtIndex:i] CGColor]];
        [self.layer addSublayer:shapeLayer];
        [self.shapeLayers addObject:shapeLayer];
    }
    
}
//计算角度
- (void)calculateAngle
{
    NSUInteger sliceCount = self.valueArray.count;
    
    double sum = 0.0;
    double value;
    for (int index = 0; index < sliceCount; index++) {
        value = [self valueForSliceAtIndex:index];
        sum += value;
    }
    
    for (int index = 0; index < sliceCount; index++) {
        value = [self valueForSliceAtIndex:index];
        double div;
        if (sum == 0)
            div = 0;
        else
            div = value / sum;
        double result = M_PI * 2 * div;
        [self.angleArray addObject:[NSNumber numberWithDouble:result]];
    }
}
//画饼方法
- (void)drawSlices
{
    double startingAngle = self.startingAngle;
    CGFloat radius = self.bounds.size.width * 0.5;

    for (int i = 0; i < self.shapeLayers.count; i++) {
        double destinationAngle = [self.angleArray[i] doubleValue] + startingAngle;
        
        CGMutablePathRef path = CGPathCreateMutable();
//        NSLog(@"%p",&path);
        CGPathMoveToPoint(path, NULL, radius, radius);
        
        CGPathAddArc(path, NULL, radius, radius, radius, startingAngle, destinationAngle, 0);
        
        CGPathCloseSubpath(path);
        
        CAShapeLayer *sublayer = self.shapeLayers[i];
        
        [sublayer setPath:path];

        CFRelease(path);
//        CGPathRelease(path);
        startingAngle = destinationAngle;
    }
}

- (CGFloat)valueForSliceAtIndex:(NSUInteger)index
{
    return [self.valueArray[index] doubleValue];
}




@end
