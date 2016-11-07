//
//  ViewController.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "ViewController.h"
#import "FDManifestReader.h"
#import "NSString+FDMD5.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    FDManifestReader *manifestReader = [[FDManifestReader alloc] init];
    [manifestReader QueryFiles];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
