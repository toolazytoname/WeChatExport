//
//  FDFileManager.m
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDFileManager.h"

@implementation FDFileManager

+ (BOOL)copyFileFrom:(NSString *)sourcepath destination:(NSString *)destinationPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSucess = [fileManager copyItemAtPath:sourcepath toPath:destinationPath error:&error];
    if (error) {
        NSLog(@"%s error:%@",__func__,error);
    }
    return isSucess;
}

@end
