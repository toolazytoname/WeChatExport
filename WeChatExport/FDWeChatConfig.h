//
//  FDWeChatConfig.h
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  结果保存目标文件目录
 */
extern NSString *const FDDestinationFolderPath;

/**
 *  Manifest数据库文件名
 */
extern NSString *const FDManifestDataBaseName;

/**
 *  Manifest数据库文件名
 */
extern NSString *const FDMMDataBaseName;

/**
 *  Mac系统备份路径
 */
extern NSString *const FDMacBackupFolderPath;

/**
 *  Host WeChat ID
 */
extern NSString *const FDHostWeChatID;

/**
 *  获取FileID 和 相对路径结果的SQL
 */
extern NSString *const FDGetWeChatFileIDAndrelativePathSQL;

@interface FDWeChatConfig : NSObject

/**
 @return Manifest数据库路径
 */
+ (NSString *)manifestPath;

/**
 @return 微信沙盒目录文件列表本地持久化存储文件名
 */
+ (NSString *)wechatSandBoxFilesArrayFilePath;

/**
 @return 登陆用户文件列表的持久化存储文件名
 */
+ (NSString *)hostWeChatFilesArrayFilePath;


/**
 @return MD5哈希后的 Host WeChat ID
 */
+ (NSString *)hostWeChatIDAfterMD5;


/**
 判断当前文件是否是这个微信ID相关的文件

 @param relativePath 沙盒中的相对路径
 @return 是表示：是这个微信ID的文件。
 */
+ (BOOL)isPathMatchHostWeChatIDWithPath:(NSString *)relativePath;


/**
 判断当前路径是否是MM数据库文件
 
 @param relativePath 沙盒中的相对路径
 @return 是表示：是这个数据库文件
 */
+ (BOOL)isMMDotsqliteWithRelativePath:(NSString *)relativePath;

@end
