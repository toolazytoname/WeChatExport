//
//  FDMMReader.h
//  WeChatExport
//
//  Created by weichao on 2016/11/8.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDDataReader.h"

@interface FDMMReader : FDDataReader

@property (nonatomic, copy) NSString *friendID;
- (void)query;
@end
