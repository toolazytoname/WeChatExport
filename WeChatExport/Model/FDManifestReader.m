//
//  FDManifestReader.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDManifestReader.h"

@interface FDManifestReader()
@property (nonatomic, strong) NSString *MMDotSqlitePath;
@end

@implementation FDManifestReader

- (NSMutableArray *)QueryFiles {
    NSMutableArray *filesArray = [self publicQueryDataWithsql:FDGetWeChatFileIDAndrelativePathSQL dataColumns:@[@(0),@(1)]];
    [self enumerateFilesArray:filesArray];
    [filesArray writeToFile:[FDWeChatConfig wechatSandBoxFilesArrayFilePath] atomically:YES];
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
            NSString *absolutePath = [FDMacBackupFolderPath stringByAppendingPathComponent:fileID];

            //寻找当前ID的相关文件
            if ([FDWeChatConfig isPathMatchHostWeChatIDWithPath:relativePath]) {
                NSArray *myIDElement = @[absolutePath,relativePath];
                [myIDDocumentFiles addObject:myIDElement];
            }
            
            if([FDWeChatConfig isMMDotsqliteWithRelativePath:relativePath]) {
                self.MMDotSqlitePath = absolutePath;
            }
        }
    }];
    [myIDDocumentFiles writeToFile:[FDWeChatConfig  hostWeChatFilesArrayFilePath] atomically:YES];
    NSLog(@"md5:%@;wechatFilesCount:%ld;myIDDocumentFilesCount:%ld",[FDWeChatConfig hostWeChatIDAfterMD5],filesArray.count,myIDDocumentFiles.count);
}



@end
