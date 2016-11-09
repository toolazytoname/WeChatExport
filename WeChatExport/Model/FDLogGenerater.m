//
//  FDLogGenerater.m
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDLogGenerater.h"


@implementation FDLogGenerater

+ (NSString *)textLogFrom:(FDMessageModel *)messageModel {
    NSMutableString *chatLog = [[NSMutableString alloc] init];
    [chatLog appendString:@"@"];
    [chatLog appendString:messageModel.createTimeString];
    if (messageModel.isMe) {
        [chatLog appendString:@" I send a"];
    }
    else {
        [chatLog appendString:@" other sends a"];
    }
    [chatLog appendString:messageModel.messageTypeContent];
    [chatLog appendString:@"."];
    
    NSString *content = [NSString stringWithFormat:@"content is %@\n",messageModel.message];
    if (messageModel.aboulutePath) {
        content = [NSString stringWithFormat:@"resource path is %@\n",messageModel.message];
    }
    [chatLog appendString:content];
    return chatLog;
}

@end
