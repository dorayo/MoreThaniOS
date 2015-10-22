//
//  MTVersionCheck.h
//  VersionCheckDemo
//
//  Created by dorayo on 15/6/2.
//  Copyright (c) 2015年 dorayo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTVersionCheck : NSObject

+ (void)operationOnVersion:(void (^) (BOOL isNewVersion))op;

@end
