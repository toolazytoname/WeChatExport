//
//  FDFileManager.m
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDFileManager.h"

@implementation FDFileManager

+ (BOOL)copyFileFrom:(NSString *)sourcepath destination:(NSString *)destinationPath iSCreate:(BOOL)iSCreate {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExist = [fileManager fileExistsAtPath:destinationPath isDirectory:&isDir];
    //传入的是一个包含文件名的完整路径
    //不存在 && 不是路径 && 要创建
    if (!isExist && !isDir && iSCreate) {
        //获取
        NSError *createError;
        NSString *directory = [destinationPath stringByDeletingLastPathComponent];
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&createError];
        if (createError) {
            NSLog(@"%s error:%@",__func__,createError);
        }
    }
    BOOL isSucess = [fileManager copyItemAtPath:sourcepath toPath:destinationPath error:&error];
    if (error) {
        NSLog(@"%s error:%@",__func__,error);
    }
    return isSucess;
}
@end
