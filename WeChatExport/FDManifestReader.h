//
//  FDManifestReader.h
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FDManifestReader : NSObject
- (NSMutableArray *)query;

- (NSMutableArray *)queryID:(NSString *)IDAftermd5 allWechatArray:(NSArray *)wechatArray;


@end
