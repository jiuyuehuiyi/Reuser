//
//  WHAddressBook.m
//  testtest
//
//  Created by dengweihao on 15/9/17.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#import "WHAddressBook.h"

@implementation WHAddressBook

- (NSMutableArray *)Emails
{
    if (!_Emails) {
        _Emails = [NSMutableArray array];
    }
    return _Emails;
}

- (NSMutableArray *)Phones
{
    if (!_Phones) {
        _Phones = [NSMutableArray array];
    }
    return _Phones;
}


@end
