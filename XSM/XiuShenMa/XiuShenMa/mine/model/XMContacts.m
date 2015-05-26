//
//  XMContacts.m
//  XiuShemMa
//
//  Created by Apple on 14/10/28.
//  Copyright (c) 2014年 xiushenma. All rights reserved.
//

#import "XMContacts.h"

@implementation XMContacts




//////////////////////////////归档//////////////////////////////
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_ID forKey:@"_ID"];
//    [encoder encodeObject:_user_id forKey:@"_userid"];
    [encoder encodeObject:_nickname forKey:@"_nickname"];
    [encoder encodeObject:_telephone forKey:@"_telephone"];
    [encoder encodeObject:_sex forKey:@"_sex"];
    [encoder encodeObject:_area forKey:@"_area"];
    [encoder encodeObject:_address forKey:@"_address"];
}
/////////////////////////////解归档/////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.ID = [decoder decodeObjectForKey:@"_ID"];
//        self.user_id = [decoder decodeObjectForKey:@"_user_id"];
        self.nickname = [decoder decodeObjectForKey:@"_nickname"];
        self.telephone = [decoder decodeObjectForKey:@"_telephone"];
        self.sex = [decoder decodeObjectForKey:@"_sex"];
        self.area = [decoder decodeObjectForKey:@"_area"];
        self.address = [decoder decodeObjectForKey:@"_address"];
    }
    return self;
}



@end
