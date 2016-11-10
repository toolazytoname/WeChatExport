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
#import "FDAudConverter.h"

@implementation FDMMReader
- (void)query {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *sql = [FDWeChatConfig friendSQLWithFriendID:self.friendID];
        NSMutableArray *filesArray = [self publicQueryDataWithsql:sql dataColumns:@[@(0),@(1),@(2),@(3),@(4)]];
        [filesArray writeToFile:[FDWeChatConfig friendSQLResultPathWithFriendID:self.friendID] atomically:YES];
        NSMutableString *chatLog = [[NSMutableString alloc] init];
        [filesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FDMessageModel *messageModel = [[FDMessageModel alloc] initWithModel:obj friendID:self.friendID];
            [FDFileManager copyFileFrom:messageModel.aboulutePath destination:messageModel.destinationPath iSCreate:YES];
            if (FDMessageTypeAudio == messageModel.messageType && messageModel.destinationPath) {
                [FDAudConverter convertAudToAMRWithPath:messageModel.destinationPath];
            }
            NSString * objLog = [FDLogGenerater textLogFrom:messageModel];
            [chatLog appendString:objLog];
        }];
        [chatLog writeToFile:[FDWeChatConfig friendChatLogPathWithFriendID:self.friendID] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    });
    }

@end
