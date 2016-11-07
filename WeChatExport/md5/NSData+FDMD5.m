//
//  NSData+FDMD5.m
//  WeChatExport
//
//  Created by weichao on 2016/11/7.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "NSData+FDMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (FDMD5)
- (NSString*)fd_md5Hash
{
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([self bytes], (unsigned int)[self length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}

@end
