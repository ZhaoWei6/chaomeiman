//
//  MMTextAttachment.m
//  Twhp
//
//  Created by mac on 15-1-26.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MMTextAttachment.h"

@implementation MMTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0)
{
    return CGRectMake( 0 , 0 , lineFrag.size.height+10 , lineFrag.size.height+10 );
}
@end
