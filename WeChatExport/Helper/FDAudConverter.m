//
//  FDAudConverter.m
//  WeChatExport
//
//  Created by weichao on 2016/11/10.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "FDAudConverter.h"

@implementation FDAudConverter

/**
 2016-11-10 15:50:39.400854 WeChatExport[50860:3445686] +[FDAudConverter convertAudToAMRWithPath:] Error Domain=NSCocoaErrorDomain Code=264 "The file “3.aud” couldn’t be opened because the text encoding of its contents can’t be determined." UserInfo={NSFilePath=/Users/weichao/Desktop/lazyTemp/3.aud}
 2016-11-10 15:50:39.400923 WeChatExport[50860:3445686] Incorrect NSStringEncoding value 0x0000 detected. Assuming NSASCIIStringEncoding. Will stop this compatiblity mapping behavior in the near future.
 2016-11-10 15:50:42.834979 WeChatExport[50860:3445686] Incorrect NSStringEncoding value 0x0000 detected. Assuming NSASCIIStringEncoding. Will stop this compatiblity mapping behavior in the near future.
 2016-11-10 15:50:42.835352 WeChatExport[50860:3445686] +[FDAudConverter convertAudToAMRWithPath:] Error Domain=NSCocoaErrorDomain Code=517 "The file “3.amr” couldn’t be saved using text encoding Western (ASCII)." UserInfo={NSFilePath=/Users/weichao/Desktop/lazyTemp/3.amr, NSStringEncoding=0}

 @param audPath audPath description
 @return return value description
 */
+ (BOOL)convertAudToAMRWithPath:(NSString *)audPath {
    if (!audPath || 0 == audPath.length) {
        return NO;
    }
    NSError *fileContentError = nil;
    NSStringEncoding encoding;
    NSString *fileContent = [NSString stringWithContentsOfFile:audPath usedEncoding:&encoding error:&fileContentError];
    if (!fileContent) {
        NSLog(@"%s %@",__func__,fileContentError);
        fileContent = [NSString stringWithContentsOfFile:audPath encoding:encoding error:&fileContentError];
        if (!fileContent) {
            NSLog(@"%s %@",__func__,fileContentError);
            return NO;
        }
    }
    NSMutableString *content = [NSMutableString stringWithString:FDAMRHeader];
    [content appendString:fileContent];
    
    NSString *amrPath = [audPath.stringByDeletingPathExtension stringByAppendingPathExtension:@"amr"];
    
    NSError *writeFileError = nil;
    BOOL isWriteAMRSucess = [content writeToFile:amrPath atomically:YES encoding:encoding error:&writeFileError];
    if (writeFileError) {
        NSLog(@"%s %@",__func__,writeFileError);
        return NO;
    }
    return isWriteAMRSucess;
}

/**
 echo '#!AMR' > /Users/weichao/Desktop/lazyTemp/3.amr;cat /Users/weichao/Desktop/lazyTemp/3.aud >> /Users/weichao/Desktop/lazyTemp/3.amr

 @param audPath audPath description
 */
+ (void)shellConvertAudToAMRWithPath:(NSString *)audPath {
    if (!audPath || 0 == audPath.length) {
        return;
    }
    NSString *amrPath = [audPath.stringByDeletingPathExtension stringByAppendingPathExtension:@"amr"];
    NSMutableString *shell = [NSMutableString stringWithFormat:@"echo '%@' > %@;",FDAMRHeader,amrPath];
    [shell appendFormat:@"cat %@ >> %@",audPath,amrPath];
    system(shell.UTF8String);
}

@end
