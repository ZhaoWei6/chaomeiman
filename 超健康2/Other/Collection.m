//
//  Collection.m
//  222
//
//  Created by imac on 14-12-4.
//  Copyright (c) 2014年 imac. All rights reserved.
//

#import "Collection.h"

@implementation Collection
-(NSString *)description{
    return [NSString stringWithFormat:@"headImage=%@ name=%@ sex=%@ age=%@ personText=%@",self.headImage,self.name,self.sex,self.age,self.personText];
}
@end
