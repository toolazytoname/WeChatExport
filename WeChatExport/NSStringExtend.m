//
//  NSStringExtend.m
//  fushihui
//
//  Created by jinzhu on 10-8-11.
//  Copyright 2010 Sharppoint Group All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "NSDataAdditions.h"



#pragma mark -	
@implementation NSString(MD5Extended)

- (NSString*)md5Hash 
{
	return [[self dataUsingEncoding:NSUTF8StringEncoding] md5Hash];
}
@end

