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
        content = [NSString stringWithFormat:@"resource path is %@\n",messageModel.destinationPath];
    }
    [chatLog appendString:content];
    return chatLog;
}


+ (NSString *)htmlFormatFrom:(FDMessageModel *)messageModel {
    NSMutableString *htmlContent = [[NSMutableString alloc] initWithString:@"<div>"];
    NSString *textLog = [[self class] textLogFrom:messageModel];
    [htmlContent appendString:textLog];
    [htmlContent appendString:@"</div>"];
    
    if (messageModel.destinationPath && 0 != messageModel.destinationPath.length) {
        [htmlContent appendString:@"<div>"];
        NSMutableString *resourceContent = nil;
        switch (messageModel.messageType) {
            case FDMessageTypeImage:{
                resourceContent = [NSMutableString stringWithFormat:
                                   @"<a href='%@'>"
                                   "<img src='%@' width='320' />"
                                   "</a>",
                                   messageModel.destinationPath,messageModel.destinationPath];
                break;
            }
            case FDMessageTypeAudio:
                resourceContent = [NSMutableString stringWithFormat:
                                   @"<a href='%@'>audiopath:%@</a>"
                                   ,messageModel.destinationPathForAmr,messageModel.destinationPathForAmr];
                break;
            case FDMessageTypeVideo:
            case FDMessageTypeShortVideo:
                resourceContent = [NSMutableString stringWithFormat:
                                   @"<video width='320' height='240' controls>"
                                   "<source src='%@' type='video/mp4'>"
                                   "Your browser does not support the video tag."
                                   "</video>",messageModel.destinationPath];
                break;
            default:
                break;
        }
        [htmlContent appendString:resourceContent];
        [htmlContent appendString:@"</div>"];
    }
    return htmlContent;
}

+ (NSString *)addHeaderAndFooter:(NSMutableString *)middle {
    NSString *headerString =
    @"<html>"
    "<head>"
    "<meta content='text/html; charset=utf-8' http-equiv='content-type'>"
    "<title>日志查看(lazy出品)</title>"
    "</head>"
    
    "<body>";
    NSString *footer =
    @"</body>"
    "</html>";
    
    NSString *html = [NSString stringWithFormat:@"%@%@%@",headerString,middle,footer];
    return html;
}

@end
