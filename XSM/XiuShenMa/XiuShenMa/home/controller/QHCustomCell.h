//
//  QHCustomCell.h
//  Demo
//
//  Created by Apple on 15/1/14.
//  Copyright (c) 2015年 ChengWei. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum QHCustionCellStyle {
    QHCustionCellStyleDefault = 0,//
    QHCustionCellStyleBunner  = 1,//
    QHCustionCellStyleMain    = 2,//
    QHCustionCellStyleHot     = 3,//
    QHCustionCellStyleOther   = 4 //
}kQHCustionCellStyle;

@interface QHCustomCell : UITableViewCell

- (id)initWithStyle:(kQHCustionCellStyle)style contentArray:(NSArray *)contentArray identifier:(NSString *)identifier;

@end
