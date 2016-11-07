//
//  FDDataReader.h
//  WeChatExport
//
//  Created by weichao on 2016/11/7.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 一个库文件，对应一个类，一共通用的公共方法都在这个基类中
 */
@interface FDDataReader : NSObject

/**
 数据库目录
 
 @return 数据库目录
 */
+ (NSString *)databasePath;


/**
 查询数据库

 @param sql sql语句
 @param dataColumns 输入想要第几列，例如:@[(0),(1)]
 @return 查询结果
 */
- (NSMutableArray *)publicQueryDataWithsql:(NSString *)sql dataColumns:(NSArray *)dataColumns;
@end
