//
//  FDMMReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/8.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDMMReader.h"
#import "FDMessageModel.h"
#import "FDLogGenerater.h"
#import "FDFileManager.h"

@implementation FDMMReader
- (NSMutableArray *)query {
    NSString *sql = [FDWeChatConfig friendSQLWithFriendID:self.friendID];
    NSMutableArray *filesArray = [self publicQueryDataWithsql:sql dataColumns:@[@(0),@(1),@(2),@(3),@(4)]];
    [filesArray writeToFile:[FDWeChatConfig friendSQLResultPathWithFriendID:self.friendID] atomically:YES];
    NSMutableString *chatLog = [[NSMutableString alloc] init];
    [filesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FDMessageModel *messageModel = [[FDMessageModel alloc] initWithModel:obj friendID:self.friendID];
        [FDFileManager copyFileFrom:messageModel.aboulutePath destination:messageModel.destinationPath iSCreate:YES];
        NSString * objLog = [FDLogGenerater textLogFrom:messageModel];
        [chatLog appendString:objLog];
    }];
    [chatLog writeToFile:[FDWeChatConfig friendChatLogPathWithFriendID:self.friendID] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return filesArray;
}

@end
