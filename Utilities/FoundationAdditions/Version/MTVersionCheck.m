//
//  MTVersionCheck.m
//  VersionCheckDemo
//
//  Created by dorayo on 15/6/2.
//  Copyright (c) 2015年 dorayo.com. All rights reserved.
//

#import "MTVersionCheck.h"

@implementation MTVersionCheck

+ (void)operationOnVersion:(void (^)(BOOL))op
{
    NSString *versionKey = (NSString *)kCFBundleVersionKey;
    
    // get current version code from info.plist
    NSString *currentVersionCode = [NSBundle mainBundle].infoDictionary[versionKey];
    
    NSString *lastVersionCode = [[NSUserDefaults standardUserDefaults] stringForKey:versionKey];
    
    BOOL isNewVersion = ![currentVersionCode isEqualToString:lastVersionCode];
    
    op(isNewVersion);
    
    if (isNewVersion) {
        // update version code
        [[NSUserDefaults standardUserDefaults] setObject:currentVersionCode forKey:versionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
