//
//  FDAudConverter.m
//  WeChatExport
//
//  Created by weichao on 2016/11/10.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDAudConverter.h"

@implementation FDAudConverter
+ (BOOL)convertAudToAMRWithPath:(NSString *)audPath {
    if (!audPath || 0 == audPath.length) {
        return NO;
    }
    NSError *fileContentError = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:audPath encoding:NSUTF8StringEncoding error:&fileContentError];
    if (fileContentError) {
        NSLog(@"%s %@",__func__,fileContentError);
        return NO;
    }
    NSMutableString *content = [NSMutableString stringWithString:FDAMRHeader];
    [content appendString:fileContent];
    
    NSString *amrPath = [audPath.stringByDeletingPathExtension stringByAppendingPathExtension:@"amr"];
    
    NSError *writeFileError = nil;
    BOOL isWriteAMRSucess = [content writeToFile:amrPath atomically:YES encoding:NSUTF8StringEncoding error:&writeFileError];
    if (writeFileError) {
        NSLog(@"%s %@",__func__,writeFileError);
        return NO;
    }
    return isWriteAMRSucess;
}

@end
