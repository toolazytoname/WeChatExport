//
//  FDMessageModel.h
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 消息类型

 - FDMessageTypeMessage: 文本
 - FDMessageTypeImage: 图片
 - FDMessageTypeVideo: 视频
 - FDMessageTypeShortVideo: 小视频
 - FDMessageTypeAudio: 语音
 - FDMessageTypeShareLink: 分享链接
 - FDMessageTypeLocation: 位置
 - FDMessageTypeEmoticon: 动画表情
 - FDMessageTypeNickName: 名片
 - FDMessageTypePhone: 语音电话，视频电话
 */
typedef NS_ENUM(NSInteger, FDMessageType) {
    FDMessageTypeMessage = 1,
    FDMessageTypeImage = 3,
    FDMessageTypeVideo = 43,
    FDMessageTypeShortVideo = 62,
    FDMessageTypeAudio = 34,
    FDMessageTypeShareLink = 49,
    FDMessageTypeLocation = 48,
    FDMessageTypeEmoticon = 47,
    FDMessageTypeNickName = 42,
    FDMessageTypePhone = 50,
};


@interface FDMessageModel : NSObject
/**
  UTC+0
 */
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger des;
@property (nonatomic, assign) NSInteger mesLocalID;

@property (nonatomic, copy)   NSString *createTimeString;
@property (nonatomic, assign) FDMessageType messageType;
@property (nonatomic, copy)   NSString *sandboxPath;
@property (nonatomic, copy)   NSString *aboulutePath;
@property (nonatomic, copy)   NSString *destinationPath;
@property (nonatomic, copy)   NSString *friendID;
@property (nonatomic, copy)   NSString *friendIDAfterMD5;
@property (nonatomic, assign) BOOL isMe;
@property (nonatomic, copy)   NSString *messageTypeContent;

- (instancetype)initWithModel:(id)model friendID:(NSString *)friendID;
@end
