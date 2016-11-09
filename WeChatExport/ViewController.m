//
//  ViewController.m
//  WeChatExport
//
//  Created by weichao on 2016/11/6.
//  Copyright © 2016年 FatGragon. All rights reserved.
//

#import "ViewController.h"
#import "FDManifestReader.h"
#import "FDMMReader.h"
#import "FDWeChatConfig.h"


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    
}

- (IBAction)outputClick:(id)sender {
    FDManifestReader *manifestReader = [[FDManifestReader alloc] init];
    manifestReader.databasePath = [FDWeChatConfig manifestPath];
    [manifestReader query];
    
    FDMMReader *mmReader = [[FDMMReader alloc] init];
    mmReader.databasePath = manifestReader.MMDotSqlitePath;
    //TODO:ID
    mmReader.friendID = @"jenny";
    [mmReader query];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
