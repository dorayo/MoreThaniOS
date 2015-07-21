//
//  UIViewController+Convenience.m
//  QYWeiBo
//
//  Created by qingyun on 15/7/4.
//  Copyright (c) 2015年 河南青云. All rights reserved.
//

#import "UIViewController+Convenience.h"

@implementation UIViewController (Convenience)

+ (UINavigationController *)navControllerFromClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

- (UINavigationController *)navController
{
    return [[UINavigationController alloc] initWithRootViewController:self];
}

@end
