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
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/oneFriend";
    return pathOfResult;
}

- (NSString *)chatlogSavePath {
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/oneFriendChatLog.txt";
    return pathOfResult;
}

- (NSString *)friendID {
    return @"";
}

- (NSMutableArray *)query {
    NSString *friendID = [self friendID];
    NSString *tableName = [self tableName];
//   CreateTime UTC+0
    NSString *sql = [NSString stringWithFormat:@"SELECT CreateTime,Message,Type,Des,MesLocalID FROM %@",tableName];
    NSMutableArray *filesArray = [self publicQueryDataWithsql:sql dataColumns:@[@(0),@(1),@(2),@(3),@(4)]];

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    NSMutableString *chatLog = [[NSMutableString alloc] init];
    [filesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            NSTimeInterval createTime = [[obj valueForKey:@"0"] floatValue];
            NSString *message = [obj valueForKey:@"1"];
            NSInteger type = [[obj valueForKey:@"2"] integerValue];
            NSInteger des = [[obj valueForKey:@"3"] integerValue];
            NSInteger mesLocalID = [[obj valueForKey:@"4"] integerValue];
            
            NSString *dateString = [self createTimeString:createTime];
            [chatLog appendString:@"at"];
            [chatLog appendString:dateString];
            BOOL isMe = [self isMe:des];
            if (isMe) {
                [chatLog appendString:@"I send:"];
            }
            else {
                [chatLog appendString:@"other sends:"];
            }
            switch (type) {
                case 1:
                    [chatLog appendString:message];
                    break;
                case 3:
                    [chatLog appendFormat:@"the imagePath is %@",[self realPathByRelativePath: [self imagePath:mesLocalID]]];
                    break;
                case 43:
                case 62:
                    [chatLog appendFormat:@"the videoPath is %@",[self realPathByRelativePath: [self littleVideoPath:mesLocalID]]];
                    break;
                case 34:
                    [chatLog appendFormat:@"the audio path is %@",[self realPathByRelativePath: [self audioPath:mesLocalID]]];
                    break;
                case 49://分享链接
                case 48:
                case 47://分享链接
                case 42://分享链接
                case 50://分享链接
                    [chatLog appendString:message];
                    break;
                default:
                    break;
            }
            [chatLog appendString:@"\n"];
        }
    }];
    [filesArray writeToFile:[self oneFriendSavePath] atomically:YES];
//    [self enumerateFilesArray:filesArray];
    [chatLog writeToFile:[self chatlogSavePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return filesArray;
}


- (NSString *)createTimeString:(NSTimeInterval)createTime {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:createTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ssz";
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

- (BOOL)isMe:(NSInteger)des {
    if (0 == des) {
        return YES;
    }
    return NO;
}

- (NSString *)tableName {
    //    NSString *tableName = [@"Chat_" stringByAppendingString:[friendID fd_md5Hash]];
    //    return tableName;
    return @"Chat_";

}

- (NSString *)encodedName {
//    NSString *tableName = [@"Chat_" stringByAppendingString:[friendID fd_md5Hash]];
//    return tableName;
    return @"";
}

/**
文本

聊天记录的数据库文件为：root\DB\MM.sqlite。

Friend表存储所有好友的信息，字段UsrName是唯一标识好友的ID，但不一定是微信ID，若用户是用QQ号申请的微信，则UsrName是qq12345678形式，若使用微信ID申请的话，则UsrName就是微信ID，若使用手机号申请的话，则UsrName就是wxid_XXXXX形式。不管怎样，将此UsrName进行MD5运算，得到的哈希值，前面加上“Chat_”得到的字符串，就是存放与此好友所有聊天记录的表名，如：Chat_a500325c723649ddb75eda10635edf82。群组也是一样。

Friend表的ShortPY字段存储了有好友的备注信息，但是编码不一样。

聊天记录表中，Message字段就是与该好友的聊天记录的所有信息，若是文本，则直接存储，其它格式，请见下面章节。其中CreateTime字段是信息产生的时间；Des字段若为0则是用户向好友发送的信息，若为1则是好友发送过来的信息；其中Type字段若为1，则该信息是文本信息。
*/


/**
 在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为3，则该信息是图片。MesLocalID字段是数字，假设为“407”，图片存储在root\Img\a500325c723649ddb75eda10635edf82\下的“407.pic”，其中“407.pic_thum”是该图片的缩略图。
 
 @return 图片路径
 */
- (NSString *)imagePath:(NSInteger)mesLocalID {
    NSString *imagePath = [NSString stringWithFormat:@"Img/%@/%ld.pic",[self encodedName],mesLocalID];
    return imagePath;
}

/**
 在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为43，则该信息是视频。MesLocalID字段是数字，假设为“8011”，视频存储在 root\Video\a500325c723649ddb75eda10635edf82 下的“8011.mp4”，其中“8011.video_thum”是该视频的缩略图

 @return 视频路径
 */
- (NSString *)littleVideoPath:(NSInteger)mesLocalID {
    NSString *videoPath = [NSString stringWithFormat:@"Video/%@/%ld.mp4",[self encodedName],mesLocalID];
    return videoPath;
}


/**
 在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为34，则该信息是语音片段。MesLocalID字段是数字，假设为“8938”，视频存储在 root\Audio\a500325c723649ddb75eda10635edf82 下的“8938.aud”。
 
 AUD文件其实就是缺少头信息的AMR文件，需要在文件头加入“#!AMR”才能成为AMR文件，然后就可以用一些播放软件打开了（其实能播放AMR的软件比较少，目前只知道QQ影音可以播放）。
 
 将AUD转换为AMR的控制台命令：copy head.txt/b + 476.aud/b 476.amr，其中head.txt中的内容就是“#!AMR”。
 
 本程序调用 FFmpeg 提供的工具转换成 WAV 文件再播放，这是一个很强大的软件，可以对许多音视频进行播放、转换格式。

 @return 语音路径
 */
- (NSString *)audioPath:(NSInteger)mesLocalID {
    NSString *audioPath = [NSString stringWithFormat:@"Audio/%@/%ld.aud",[self encodedName],mesLocalID];
    return audioPath;
}

//在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为49，则该信息是分享链接，在Message字段中<url></url>之间的就是链接地址。

//在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为48，则该信息是非实时位置信息，在Message字段中有具体的位置坐标，在该信息的XML结构里：msg –> location –> x 与 y 字段中存储着位置坐标。


//在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为47，则该信息是一个动画表情。在该信息的XML结构里：msg –> emoji –> md5字段中存储着表情的md5值，假设该表情的MD5值是：d0546d1d8940bf82def5cc8b19185e1a，则在iPhone微信的文件目录中：/Library/WechatPrivate/emoticon1，存储着以该MD5值为文件名的文件，如：d0546d1d8940bf82def5cc8b19185e1a.pic，其实它是一个GIF文件，这样就可以连接到该表情了。

//在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为42，则该信息是一个名片，在该信息的XML结构里：msg –> username 字段中存储着微信ID，msg –> nickname 字段中存储着微信名。

//在好友的聊天记录表中，假设为 Chat_ a500325c723649ddb75eda10635edf82 表，若字段Type为50，则该信息是一个电话记录。里面有时长信息：<duration></duration>


- (NSString *)realPathByRelativePath:(NSString *)relativePath {
    NSString *idPath = [self myIDDocumentFileSaveToPath];
    NSArray *idArray = [[NSArray alloc] initWithContentsOfFile:idPath];
    __block NSString *result;
    [idArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *elementArray = (NSArray *)obj;
        NSString *relativeFromFile = (NSString *)elementArray[1];
        if ([relativeFromFile hasSuffix:relativePath]) {
            result = elementArray[0];
            *stop = YES;
        }
    }];
    return result;
}

- (NSString *)myIDDocumentFileSaveToPath {
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/myIDDocument";
    return pathOfResult;
}

@end
