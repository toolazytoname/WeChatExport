//
//  FDManifestReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDManifestReader.h"
#import <sqlite3.h>

static sqlite3 *database = NULL;

@implementation FDManifestReader


- (NSMutableArray *)query {
    NSMutableArray *result = nil;
    NSString *path = [[self class] pathWithDatabase];
    BOOL isSucess = [self initializeDatabaseWithPath:path];
    if (isSucess) {
        [self openDatabaseWithPath:path];
        result = [self getWechatInfoWithPath:path];
        [self closeDatabase];
    }
    return result;
}

- (NSMutableArray *)queryID:(NSString *)IDAftermd5 allWechatArray:(NSArray *)wechatArray {
    __block NSMutableArray *currentIDArray = [[NSMutableArray alloc] init];
    NSString *compareString = [@"Documents" stringByAppendingPathComponent:IDAftermd5];
    [wechatArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *path = [[dic allValues] firstObject];
            if ([path containsString:compareString]) {
                [currentIDArray addObject:dic];
            }
        }
    }];
    return currentIDArray;
}



+ (NSString *)pathWithBackupFolder {
    return @"/Users/weichao/Desktop/wechat/7c944decd417833ed3954f4cc32c0f0e0cf9c14a";
}


+ (NSString *)pathWithDatabase {
    return [[[self class] pathWithBackupFolder] stringByAppendingPathComponent:@"Manifest.db"];
}

- (BOOL)initializeDatabaseWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    bool isExit = [fileManager fileExistsAtPath:path];
    return isExit;
}

- (void)openDatabaseWithPath:(NSString *)path
{
    // 是否打开成功
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        NSLog(@"Opening Database");
    }
    else {
        // 打开数据库失败
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database: '%s'.", sqlite3_errmsg(database));
    }
}


- (NSMutableArray *)getWechatInfoWithPath:(NSString *)path {
        // 查询语句
    char *const sql = "SELECT fileID,relativePath FROM Files WHERE domain='AppDomain-com.tencent.xin'";
    // 将sql文本转换成一个准备语句
    sqlite3_stmt *statement;
    int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
    // 装查询结果的可变数组
    NSMutableArray *arrayM = [NSMutableArray array];
    // 结果状态为OK时，开始取出每条数据
    if ( sqlResult == SQLITE_OK) {
        // 只要还有下一行，就取出数据。
        while (sqlite3_step(statement) == SQLITE_ROW) {
            // 每列数据
            char *fileID = (char *)sqlite3_column_text(statement, 0);
            char *relativePath = (char *)sqlite3_column_text(statement, 1);
            NSString *fileIDString = [self stringWithCharString:fileID];
            NSString *relativePathString = [self stringWithCharString:relativePath];
            
//            NSString *key = [[fileIDString substringWithRange:NSMakeRange(0, 2)] stringByAppendingPathComponent:fileIDString];
            
            NSString *key = [[fileIDString substringWithRange:NSMakeRange(0, 2)] stringByAppendingPathComponent:fileIDString];
            key = [[[self class] pathWithBackupFolder] stringByAppendingPathComponent:key];
            NSString *path = relativePathString;
            NSDictionary *dic = @{key: path};
            // 添加进数组
            [arrayM addObject:dic];
        }
        // 完成后释放prepare创建的准备语句
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"Problem with database:");
        NSLog(@"%d",sqlResult);
    }
    return arrayM;
    

}

/** C字符串转换OC字符串 */
- (NSString *) stringWithCharString:(char *)string
{
    return (string) ? [NSString stringWithUTF8String:string] : @"";
}


- (void)closeDatabase
{
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Failed to close database: '%s'.", sqlite3_errmsg(database));
    }
}


@end
