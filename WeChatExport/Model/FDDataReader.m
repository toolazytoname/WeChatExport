//
//  FDDataReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/7.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDDataReader.h"
#import <sqlite3.h>

static sqlite3 *database = NULL;

@implementation FDDataReader
- (NSMutableArray *)publicQueryDataWithsql:(NSString *)sql dataColumns:(NSArray *)dataColumns {
    if (!sql || sql.length == 0) {
        return nil;
    }
    if (!dataColumns || dataColumns.count == 0) {
        return nil;
    }
    BOOL isExistsDatabase = [self isExistsDatabase];
    NSMutableArray *result = nil;
    if (isExistsDatabase) {
        [self openDatabase];
        result = [self queryDataWithsql:sql dataColumns:dataColumns];
        [self closeDatabase];
    }
    return result;
}

+ (NSString *)databasePath {
    return @"";
}

- (BOOL)isExistsDatabase{
    NSString *databasePath = [[self class] databasePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool isExist = [fileManager fileExistsAtPath:databasePath];
    return isExist;
}

- (void)openDatabase {
    NSString *databasePath = [[self class] databasePath];
    // 是否打开成功
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        NSLog(@"Opening Database");
    }
    else {
        // 打开数据库失败
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database));
    }
}

//返回数据里面是字典
- (NSMutableArray *)queryDataWithsql:(NSString *)sql dataColumns:(NSArray *)dataColumns {
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
    // 装查询结果的可变数组
    NSMutableArray *mutableResult = [NSMutableArray array];
    // 结果状态为OK时，开始取出每条数据
    if ( sqlResult == SQLITE_OK) {
        // 只要还有下一行，就取出数据。
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *element = [[NSMutableDictionary alloc] init];
            for (NSNumber *indexNumber in dataColumns) {
                //此处是不是可以有办法获取，一共多少列，这样就可以去除这个参数dataColumns
                char *field = (char *)sqlite3_column_text(statement, [indexNumber intValue]);
                NSString *fieldString = [self stringWithCharString:field];
                if (fieldString && fieldString.length > 0) {
                    [element setValue:fieldString forKey:[indexNumber stringValue]];
                }
            }
            [mutableResult addObject:element];
        }
        // 完成后释放prepare创建的准备语句
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"Problem with database:");
        NSLog(@"%d",sqlResult);
    }
    return mutableResult;
   
}

/** C字符串转换OC字符串 */
- (NSString *)stringWithCharString:(char *)string {
    return (string) ? [NSString stringWithUTF8String:string] : @"";
}


- (void)closeDatabase {
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Failed to close database: '%s'.", sqlite3_errmsg(database));
    }
}
@end
