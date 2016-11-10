//
//  FDMessageModel.m
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDMessageModel.h"
#import "FDWeChatConfig.h"


@implementation FDMessageModel

- (instancetype)initWithModel:(id)model friendID:(NSString *)friendID {
    self = [self init];
    if (!model) {
        return self;
    }
    self.friendID = friendID;
    self.friendIDAfterMD5 = [FDWeChatConfig friendIDAfterMD5:friendID];
    
    NSDictionary *modelDictionary = (NSDictionary *)model;
    self.createTime = [[modelDictionary valueForKey:@"0"] floatValue];
    self.message = [modelDictionary valueForKey:@"1"];
    self.type = [[modelDictionary valueForKey:@"2"] integerValue];
    self.des = [[modelDictionary valueForKey:@"3"] integerValue];
    self.mesLocalID = [[modelDictionary valueForKey:@"4"] integerValue];
    
    self.createTimeString = [self createTimeString:self.createTime];
    self.messageType = self.type;
    self.sandboxPath = [self sandboxPathWithType:self.messageType mesLocalID:self.mesLocalID];
    self.isMe = [self isMe:self.des];
    self.aboulutePath = [self absolutePathBySandboxPath:self.sandboxPath];
    self.destinationPath = [self destinationPathWithSandboxPath:self.sandboxPath friendID:self.friendID];
    self.messageTypeContent = [self messageTypeContentWithType:self.messageType];
    self.destinationPathForAmr = [self amrPathWithAudPath:self.destinationPath];
    self.relativePathToHtml = [self relativePathToHtmlWithWithSandboxPath:self.sandboxPath friendID:self.friendID];
    return self;
}

- (NSString *)createTimeString:(NSTimeInterval)createTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ssz";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}
- (NSString *)relativePathToHtmlWithWithSandboxPath:(NSString *)sandboxPath friendID:(NSString *)friendID {
    if(!sandboxPath || 0 == sandboxPath.length) {
        return nil;
    }
    NSString *friendIDAfterMD5 = [FDWeChatConfig friendIDAfterMD5:friendID];
    NSString *relativePathToHtml = [[NSString alloc] initWithFormat:@"%@/%@",friendIDAfterMD5,sandboxPath];
    return relativePathToHtml;
}

- (NSString *)destinationPathWithSandboxPath:(NSString *)sandboxPath friendID:(NSString *)friendID {
    if(!sandboxPath || 0 == sandboxPath.length) {
        return nil;
    }
    NSString *friendIDAfterMD5 = [FDWeChatConfig friendIDAfterMD5:friendID];
    NSString *destination = [[NSString alloc] initWithFormat:@"%@/%@/%@",FDDestinationFolderPath,friendIDAfterMD5,sandboxPath];
    return destination;
}
- (NSString *)amrPathWithAudPath:(NSString *)audPath {
    if (!audPath || 0 == audPath.length) {
        return nil;
    }
    NSString *amrPath = [audPath.stringByDeletingPathExtension stringByAppendingPathExtension:@"amr"];
    return amrPath;
}

- (NSString *)sandboxPathWithType:(FDMessageType)type mesLocalID:(NSInteger)mesLocalID {
    NSString *sandboxPath = nil;
    switch (type) {
        case FDMessageTypeImage:
            sandboxPath = [NSString stringWithFormat:@"Img/%@/%ld.pic",self.friendIDAfterMD5,mesLocalID];
            break;
        case FDMessageTypeVideo:
        case FDMessageTypeShortVideo:
            sandboxPath = [NSString stringWithFormat:@"Video/%@/%ld.mp4",self.friendIDAfterMD5,mesLocalID];
            break;
        case FDMessageTypeAudio:
            sandboxPath = [NSString stringWithFormat:@"Audio/%@/%ld.aud",self.friendIDAfterMD5,mesLocalID];
            break;
        case FDMessageTypeShareLink:
        case FDMessageTypeLocation:
        case FDMessageTypeEmoticon:
        case FDMessageTypeNickName:
        case FDMessageTypePhone:
            break;
        default:
            break;
    }
    return sandboxPath;
}

- (BOOL)isMe:(NSInteger)des {
    if (0 == des) {
        return YES;
    }
    return NO;
}

- (NSString *)absolutePathBySandboxPath:(NSString *)sandboxPath {
    if(!sandboxPath || 0 == sandboxPath.length) {
        return nil;
    }
    NSString *idPath = [FDWeChatConfig hostWeChatFilesArrayFilePath];
    NSArray *idArray = [[NSArray alloc] initWithContentsOfFile:idPath];
    __block NSString *result = nil;;
    [idArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *elementArray = (NSArray *)obj;
        NSString *relativeFromFile = (NSString *)elementArray[1];
        if ([relativeFromFile hasSuffix:sandboxPath]) {
            result = elementArray[0];
            *stop = YES;
        }
    }];
    return result;
}

- (NSString *)messageTypeContentWithType:(FDMessageType)type {
    NSString *messageTypeContent = @"un enumated type";
    switch (type) {
        case FDMessageTypeMessage:
            messageTypeContent = @"文字";
            break;
        case FDMessageTypeImage:
            messageTypeContent = @"图片";
            break;
        case FDMessageTypeVideo:
            messageTypeContent = @"视频";
            break;
        case FDMessageTypeShortVideo:
            messageTypeContent = @"小视屏";
            break;
        case FDMessageTypeAudio:
            messageTypeContent = @"音频";
            break;
        case FDMessageTypeShareLink:
            messageTypeContent = @"链接分享";
            break;
        case FDMessageTypeLocation:
            messageTypeContent = @"位置";
            break;
        case FDMessageTypeEmoticon:
            messageTypeContent = @"表情";
            break;
        case FDMessageTypeNickName:
            messageTypeContent = @"名片";
            break;
        case FDMessageTypePhone:
            messageTypeContent = @"电话";
            break;
        default:
            break;
    }
    return messageTypeContent;
}

@end
