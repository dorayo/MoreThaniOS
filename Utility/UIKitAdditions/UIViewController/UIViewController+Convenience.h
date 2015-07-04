//
//  UIViewController+Convenience.h
//  QYWeiBo
//
//  Created by qingyun on 15/7/4.
//  Copyright (c) 2015年 河南青云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Convenience)

/*
 根据类名生成视图控制器，并绑定到新创建的导航控制器的根视图控制器，然后返回该导航控制器
 */
+ (UINavigationController *)navControllerFromClassName:(NSString *)className;

/*
 向该视图控制器对象发送该消息后返回封装好的导航控制器对象
 */
- (UINavigationController *)navController;

@end
