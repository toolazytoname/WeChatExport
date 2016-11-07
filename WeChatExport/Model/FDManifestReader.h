//
//  FDManifestReader.h
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDDataReader.h"


/**
 Manifest.db文件读取类
 */
@interface FDManifestReader : FDDataReader
@property (nonatomic, strong, readonly) NSString *MMDotSqlitePath;


/**
 从数据库获取数据，在一次遍历过程中把所有需要的数据都取出来

 @return 结果
 */
- (NSMutableArray *)QueryFiles;


@end
