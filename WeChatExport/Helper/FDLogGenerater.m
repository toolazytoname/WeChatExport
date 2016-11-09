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
    NSString *who = nil;
    if (messageModel.isMe) {
        who = @"I";
    }
    else {
        who = messageModel.friendID;
    }
    [chatLog appendFormat:@" %@ send a ",who];
    
    [chatLog appendString:messageModel.messageTypeContent];
    [chatLog appendString:@"."];
    
    NSString *content = [NSString stringWithFormat:@"content is %@\n",messageModel.message];
    if (messageModel.sandboxPath) {
        content = [NSString stringWithFormat:@"resource path is %@\n",messageModel.sandboxPath];
    }
    [chatLog appendString:content];
    return chatLog;
}

+ (NSString *)htmlFormatFrom:(FDMessageModel *)messageModel {
//    NSMutableString *htmlContent = [nsmutable ]@"<div>";
//    NSString *textLog = [[self class] textLogFrom:messageModel];
//    htmlContent
//    
//
    return nil;
}

@end
