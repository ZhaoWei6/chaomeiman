//
//  TGCategory.h
//  团购
//
//  Created by app04 on 14-7-24.
//  Copyright (c) 2014年 app04. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface XMCategory : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *subcategories;

@end
