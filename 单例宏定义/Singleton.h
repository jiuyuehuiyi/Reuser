//
//  Singleton.h
//  singleIntance
//
//  Created by dengweihao on 15/7/6.
//  Copyright (c) 2015年 vcyber. All rights reserved.
//

#define SingletonInterface(className) \
\
+ (instancetype)shared##className;

#define SingletonImplementation(className) \
\
static className *shared##className = nil; \
\
+ (instancetype)shared##className \
{ \
    static dispatch_once_t onceToKen; \
    dispatch_once(&onceToKen, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
} \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [super allocWithZone:zone]; \
    }); \
    return shared##className; \
} \

