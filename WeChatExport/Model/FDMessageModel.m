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
    self.messageTypeContent = [self messageTypeContentWithType:self.messageType];
    
    return self;
}

- (NSString *)createTimeString:(NSTimeInterval)createTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ssz";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (NSString *)destinationPathWithSandboxPath:(NSString *)sandboxPath friendIDAfterMD5:(NSString *)friendIDAfterMD5 {
    NSString *destination = [[NSString alloc] initWithFormat:@"%@/%@/%@",FDDestinationFolderPath,friendIDAfterMD5,sandboxPath];
    return destination;
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
    NSString *messageTypeContent = nil;
    switch (type) {
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
            break;
        default:
            break;
    }
    return messageTypeContent;
}

@end
