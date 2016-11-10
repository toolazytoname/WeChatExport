//
//  FDAudConverter.h
//  WeChatExport
//
//  Created by weichao on 2016/11/10.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDWeChatConfig.h"

@interface FDAudConverter : NSObject
+ (BOOL)convertAudToAMRWithPath:(NSString *)audPath;
@end
