//
//  WHModel.h
//  TestFB
//
//  Created by dengweihao on 15/12/16.
//  Copyright © 2015年 dengweihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMResultSet;

@interface WHModel : NSObject

@property (nonatomic, assign) int sId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) int score;

+(WHModel *)modelWithSet:(FMResultSet *)set;

@end
