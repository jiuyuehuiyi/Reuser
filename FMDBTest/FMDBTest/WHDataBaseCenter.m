//
//  WHDataBaseCenter.m
//  TestFB
//
//  Created by dengweihao on 15/12/16.
//  Copyright © 2015年 dengweihao. All rights reserved.
//

#import "WHDataBaseCenter.h"
#import "WHModel.h"

#define dbPath @"/Users/dengweihao/Desktop/StudentInfo.rdb"

@interface WHDataBaseCenter ()

@property(nonatomic, strong)dispatch_queue_t serialQueue;

@end

@implementation WHDataBaseCenter

static WHDataBaseCenter *center = nil;
+ (WHDataBaseCenter *)sharedDataBase {
    @synchronized(self) {
        if (center == nil) {
            center = [[WHDataBaseCenter alloc] init];
        }
    }
    return center;
}

- (id)init {
    if (self = [super init]) {
        _databasePath = [NSString stringWithFormat:dbPath];
        _database = [FMDatabase databaseWithPath:_databasePath];
        _serialQueue = dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

//创建表
- (void)testCreateTable {
    dispatch_async(_serialQueue, ^{
        if ([_database open]) {
            NSString *sqlCreateTable =  @"CREATE TABLE IF NOT EXISTS studentInfo(sId INTEGER,username varchar(32),password varchar(32),score INTEGER)";
            BOOL isSuc = [_database executeUpdate:sqlCreateTable];
            if (!isSuc) {
                NSLog(@"表创建失败");
            } else {
                NSLog(@"表创建成功");
            }
            [_database close];
        } else {
            NSLog(@"创建表时打开数据库失败");
        }
    });
}

//查询表
- (void)testSearchData {
    dispatch_async(_serialQueue, ^{
        if ([_database open]) {
            NSString *select = @"SELECT * FROM studentInfo";
            FMResultSet *rs = [_database executeQuery:select];
            while ([rs next]) {
                WHModel *model = [WHModel modelWithSet:rs];
                NSLog(@"sId = %d, username = %@, password = %@  score = %i", model.sId, model.username, model.password, model.score);
            }
            [_database close];
        } else {
            NSLog(@"查询时打开数据库失败");
        }
    });
}

//插入
- (void)testInsertData {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:_databasePath];
    
    dispatch_async(_serialQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            int myId = 1;
            NSString *username = [NSString stringWithFormat:@"张三%i",myId];
            NSString *password = @"123456";
            int score = arc4random()%100;
            
            NSString *insertSql = @"INSERT INTO studentInfo(sId,username,password,score) values(?,?,?,?)";
            
            BOOL isSuc = [db executeUpdate:insertSql, [NSString stringWithFormat:@"%i",myId], username, password, [NSString stringWithFormat:@"%i",score]];
            if (!isSuc) {
                NSLog(@"插入数据 %@ 失败", username);
            } else {
                NSLog(@"插入数据 %@ 成功", username);
            }
        }];
    });
    
    dispatch_async(_serialQueue, ^{
        [queue inDatabase:^(FMDatabase *db) {
            int myId = 2;
            NSString *username = [NSString stringWithFormat:@"李四%i",myId];
            NSString *password = @"654321";
            int score = arc4random()%100;
            
            NSString *insertSql = @"INSERT INTO studentInfo(sId,username,password,score) values(?,?,?,?)";
            
            BOOL isSuc = [db executeUpdate:insertSql, [NSString stringWithFormat:@"%i",myId], username, password, [NSString stringWithFormat:@"%i",score]];
            if (!isSuc) {
                NSLog(@"插入数据 %@ 失败", username);
            } else {
                NSLog(@"插入数据 %@ 成功", username);
            }
        }];
    });
}

//删除
- (void)testDeleteData{
    dispatch_async(_serialQueue, ^{
        if ([_database open]) {
            NSString *delete = @"DELETE FROM studentInfo WHERE username = ?";
            BOOL isSuc = [_database executeUpdate:delete, @"张三1"];
            if (isSuc) {
                NSLog(@"数据删除成功");
            }else{
                NSLog(@"数据删除失败");
            }
        } else {
            NSLog(@"删除时打开数据库失败");
        }
    });
}

@end
