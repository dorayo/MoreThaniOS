//
//  UIViewController+Convenience.m
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
