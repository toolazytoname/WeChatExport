//
//  FDFileManager.h
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDFileManager : NSObject

+ (BOOL)copyFileFrom:(NSString *)sourcepath destination:(NSString *)destinationPath iSCreate:(BOOL)iSCreate;

@end
