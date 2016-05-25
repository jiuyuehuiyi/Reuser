//
//  WHDataBaseCenter.h
//  TestFB
//
//  Created by dengweihao on 15/12/16.
//  Copyright © 2015年 dengweihao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface WHDataBaseCenter : NSObject

@property(nonatomic, strong)FMDatabase *database;
@property(nonatomic, strong)NSString *databasePath;

+ (WHDataBaseCenter *)sharedDataBase;

//创建表
- (void)testCreateTable;

//查询表
- (void)testSearchData;

//插入
- (void)testInsertData;

//删除
- (void)testDeleteData;



@end
