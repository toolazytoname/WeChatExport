//
//  FDLogGenerater.h
//  WeChatExport
//
//  Created by weichao on 2016/11/9.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDMessageModel.h"

@interface FDLogGenerater : NSObject
+ (NSString *)textLogFrom:(FDMessageModel *)messageModel;
@end
