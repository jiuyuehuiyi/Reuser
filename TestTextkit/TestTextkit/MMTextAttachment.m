//
//  MMTextAttachment.m
//  TestTextkit
//
//  Created by dengweihao on 15/10/12.
//  Copyright © 2015年 vcyber. All rights reserved.
//

#import "MMTextAttachment.h"

@implementation MMTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0)
{
    return CGRectMake( 0 , 0 , lineFrag.size.height , lineFrag.size.height );
}

@end
