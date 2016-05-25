//
//  WHModel.m
//  TestFB
//
//  Created by dengweihao on 15/12/16.
//  Copyright © 2015年 dengweihao. All rights reserved.
//

#import "WHModel.h"
#import "FMResultSet.h"

@implementation WHModel

+ (WHModel *)modelWithSet:(FMResultSet *)set {
    return [[WHModel alloc] initWithSet:set];
}

- (id)initWithSet:(FMResultSet *)set{
    if (self = [super init]) {
        _sId = [set intForColumnIndex:0];
        _username = [set stringForColumnIndex:1];
        _password = [set stringForColumnIndex:2];
        _score = [set intForColumnIndex:3];
    }
    return self;
}

@end
