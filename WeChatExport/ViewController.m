//
//  ViewController.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "ViewController.h"
#import "FDManifestReader.h"
#import "NSStringExtend.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *myID = @"shuitaiyang747";
    NSString *myIDAfterMD5 =  [myID md5Hash];
    
    FDManifestReader *manifestReader = [[FDManifestReader alloc] init];
    NSMutableArray *data = [manifestReader query];
    
    NSMutableArray *currentIDData = [manifestReader queryID:myIDAfterMD5 allWechatArray:data];
    
    NSLog(@"md5:%@;all:%ld;current:%ld",myIDAfterMD5,data.count,currentIDData.count);
    
    NSString *pathOfResult = @"/Users/weichao/Desktop/wechat/keysAndValues";
    
    [currentIDData writeToFile:pathOfResult atomically:YES];
    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
