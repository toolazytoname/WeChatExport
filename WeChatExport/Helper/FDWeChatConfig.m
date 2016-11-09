//
//  FDWeChatConfig.m
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDWeChatConfig.h"
#import "NSString+FDMD5.h"

NSString *const FDDestinationFolderPath = @"/Users/weichao/Desktop/wechat";
NSString *const FDManifestDataBaseName = @"Manifest.db";
NSString *const FDMMDataBaseName = @"MM.sqlite";
NSString *const FDMacBackupFolderPath = @"/Users/weichao/Library/Application Support/MobileSync/Backup/7c944decd417833ed3954f4cc32c0f0e0cf9c14a";
//TODO:自己账号ID
NSString *const FDHostWeChatID = @"shutaiyang747";
NSString *const FDGetWeChatFileIDAndrelativePathSQL = @"SELECT fileID,relativePath FROM Files WHERE domain='AppDomain-com.tencent.xin'";

@implementation FDWeChatConfig

+ (NSString *)manifestPath {
    NSString *manifestPath = [FDMacBackupFolderPath stringByAppendingPathComponent:FDManifestDataBaseName];
    return manifestPath;
}

+ (NSString *)wechatSandBoxFilesArrayFilePath {
    NSString *fileName = @"WechatSandBoxFilesArray";
    NSString *path = [FDDestinationFolderPath stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)hostWeChatFilesArrayFilePath {
    NSString *fileName = [FDHostWeChatID stringByAppendingString:@"FilesArray"];
    NSString *path = [FDDestinationFolderPath stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)hostWeChatIDAfterMD5 {
    NSString *hostWeChatIDAfterMD5 = [FDHostWeChatID fd_md5Hash];
    return hostWeChatIDAfterMD5;
}

+ (BOOL)isPathMatchHostWeChatIDWithPath:(NSString *)relativePath; {
    NSString *hostWeChatIDAfterMD5 = [[self class] hostWeChatIDAfterMD5];
    NSString *currentIDDocuments = [@"Documents" stringByAppendingPathComponent:hostWeChatIDAfterMD5];
    if ([relativePath containsString:currentIDDocuments]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isMMDotsqliteWithRelativePath:(NSString *)relativePath {
    if ([relativePath hasSuffix:FDMMDataBaseName]) {
        return YES;
    }
    return NO;
}

+ (NSString *)friendTableNameWithFriendID:(NSString *)friendID {
    NSString *friendIDAfterMD5 = [[self class] friendIDAfterMD5:friendID];
    NSString *tableName = [@"Chat_" stringByAppendingString:friendIDAfterMD5];
    return tableName;
}

+ (NSString *)friendChatLogPathWithFriendID:(NSString *)friendID {
    NSString *path = [[FDDestinationFolderPath stringByAppendingPathComponent:friendID] stringByAppendingString:@"ChatLog"];
    return path;
}

+ (NSString *)friendSQLResultPathWithFriendID:(NSString *)friendID {
    NSString *path = [[FDDestinationFolderPath stringByAppendingPathComponent:friendID] stringByAppendingString:@"SQLResult"];
    return path;
}

+ (NSString *)friendSQLWithFriendID:(NSString *)friendID {
    NSString *tableName = [[self class] friendTableNameWithFriendID:friendID];
    NSString *sql = [NSString stringWithFormat:@"SELECT CreateTime,Message,Type,Des,MesLocalID FROM %@",tableName];
    return sql;
}

+ (NSString *)friendIDAfterMD5:(NSString *)friendID {
    //TODO:md5后的ID
    NSString *friendIDAfterMD5 = @"b069ed0823fc2d57d25d37da69434ab1";//[friendID fd_md5Hash];
    return friendIDAfterMD5;
}
@end
