//
//  XMPickerView.h
//  XiuShemMa
//
//  Created by Apple on 14/10/21.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum kPickerViewStyle {
    kPickerViewStyleTime  = 0,
    kPickerViewStyleModel = 1,
    kPickerViewStyleDesc  = 2
}kPickerViewStyle;

@protocol XMPickerViewDelegate <NSObject>

@optional
- (void)cancleOption;
- (void)enterOptionWithContent:(NSString *)string dictionary:(NSDictionary *)dic ;
@end

@interface XMPickerView : UIView

@property (nonatomic , copy) NSString *titleStr;
@property (nonatomic , assign) id <XMPickerViewDelegate> delegate;
@property (nonatomic , assign) kPickerViewStyle pickerViewStyle;

@property (nonatomic , retain) NSArray *item;//型号
@property (nonatomic , retain) NSArray *attributecategory;
@property (nonatomic , retain) NSArray *faultcategory;//故障

@end
