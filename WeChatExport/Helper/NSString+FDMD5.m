//
//  NSString+FDMD5.m
//  WeChatExport
//
//  Created by weichao on 2016/11/7.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "NSString+FDMD5.h"
#import "NSData+FDMD5.h"

@implementation NSString (FDMD5)
- (NSString *)fd_md5Hash {
    return [[self dataUsingEncoding:NSUTF8StringEncoding] fd_md5Hash];
}

@end
