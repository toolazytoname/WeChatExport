//
//  FDMMReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/8.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDMMReader.h"

@implementation FDMMReader

- (NSString *)oneFriendSavePath {
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/ontFriend";
    return pathOfResult;
}

- (NSMutableArray *)query {
    NSString *friendID = @"";
    NSString *tableName = [self tableNameFromID:friendID];
    NSString *sql = [NSString stringWithFormat:@"SELECT UsrName,NickName FROM %@",tableName];
    NSMutableArray *filesArray = [self publicQueryDataWithsql:sql dataColumns:@[@(0),@(1)]];
    [filesArray writeToFile:[self oneFriendSavePath] atomically:YES];
//    [self enumerateFilesArray:filesArray];
    return filesArray;
}


- (NSString *)tableNameFromID:(NSString *)friendID {
//    NSString *tableName = [@"Chat_" stringByAppendingString:[friendID fd_md5Hash]];
//    return tableName;
    return @"";
    
}
@end
