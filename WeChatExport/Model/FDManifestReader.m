//
//  FDManifestReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDManifestReader.h"
#import "NSString+FDMD5.h"
#import <sqlite3.h>


@implementation FDManifestReader

+ (NSString *)databasePath {
    return [[[self class] backupFolderPath] stringByAppendingPathComponent:@"Manifest.db"];
}

+ (NSString *)backupFolderPath {
    return @"/Users/weichao/Library/Application\ Support/MobileSync/Backup/7c944decd417833ed3954f4cc32c0f0e0cf9c14a";
}

- (NSString *)myIDString {
    NSString *myID = @"shuitaiyang747";
    return myID;
}

- (NSString *)myIDDocumentFileSaveToPath {
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/myIDDocument";
    return pathOfResult;
}

- (NSString *)wechatFileSaveToPath {
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/wechat";
    return pathOfResult;
}


- (NSMutableArray *)QueryFiles {
    NSString *sql = @"SELECT fileID,relativePath FROM Files WHERE domain='AppDomain-com.tencent.xin'";
    NSMutableArray *filesArray = [self publicQueryDataWithsql:sql dataColumns:@[@(0),@(1)]];
    [filesArray writeToFile:[self wechatFileSaveToPath] atomically:YES];
    [self enumerateFilesArray:filesArray];
    return filesArray;
}


- (void)enumerateFilesArray:(NSArray *)filesArray {
    //当前ID的目录数据
    NSMutableArray *myIDDocumentFiles = [[NSMutableArray alloc] init];
    [filesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj && [obj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *element = (NSDictionary *)obj;
            NSString *fileID = [element valueForKey:@"0"];
            NSString *relativePath = [element valueForKey:@"1"];
            
            fileID = [[fileID substringWithRange:NSMakeRange(0, 2)] stringByAppendingPathComponent:fileID];
            NSString *absolutePath = [[[self class] backupFolderPath] stringByAppendingPathComponent:fileID];

            //寻找当前ID的相关文件
            if ([self isFileMatchID:[self myIDString] relativePath:relativePath] ) {
                NSArray *myIDElement = @[absolutePath,relativePath];
                [myIDDocumentFiles addObject:myIDElement];
            }
        }
    }];
    [myIDDocumentFiles writeToFile:[self myIDDocumentFileSaveToPath] atomically:YES];
    NSLog(@"md5:%@;wechatFilesCount:%ld;myIDDocumentFilesCount:%ld",[[self myIDString] fd_md5Hash],filesArray.count,myIDDocumentFiles.count);

}

- (BOOL)isFileMatchID:(NSString *)ID relativePath:(NSString *)relativePath {
    NSString *IDAfterMD5 = [ID fd_md5Hash];
    NSString *currentIDDocuments = [@"Documents" stringByAppendingPathComponent:IDAfterMD5];
    if ([relativePath containsString:currentIDDocuments]) {
        return YES;
    }
    return NO;
}



@end
