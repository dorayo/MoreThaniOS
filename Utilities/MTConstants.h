#ifndef MTCONSTANTS_H
#define MTCONSTANTS_H

// 1. 常用变量
// 1.1 Log
#ifdef DEBUG // 调试版本
#define MTLog(...) NSLog(__VA_ARGS__)
#else // 发布版本
#define MTLog(...) 
#endif
#define MTDebugLog(s, ...) MTLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert7(s, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(s), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]
#define kTipAlert(s, ...) {UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"                                                      message:[NSString stringWithFormat:(s), ##__VA_ARGS__]                                                       preferredStyle:UIAlertControllerStyleAlert];UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault                                                     handler:^(UIAlertAction * action) {}];[alert addAction:defaultAction];[self presentViewController:alert animated:YES completion:nil];}


// 1.2 weak or strong variable
#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define MTStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define MTStrong(weakVar, _var) MTStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define MTWeak_(var) MTWeak(var, weak_##var);
#define MTStrong_(var) MTStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define MTWeakSelf      MTWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define MTStrongSelf    MTStrong(__weakSelf, _self);

// 1.3 版本
#define kVersionCoding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuildCoding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#define kHigher_iOS_8_3 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_8_3)

// 1.4 iPhone设备及屏幕适配
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

// 1.5 其他UIKit相关
#define RGB(A, B, C)  [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0]
#define UI_NAVIGATION_BAR_HEIGHT    44
#define UI_TAB_BAR_HEIGHT           49
#define UI_STATUS_BAR_HEIGHT        20
#define UI_SCREEN_WIDTH             320
#define UI_SCREEN_HEIGHT            480

#define UI_LABEL_LENGTH             200
#define UI_LABEL_HEIGHT             15
#define UI_LABEL_FONT_SIZE          12
#define UI_LABEL_FONT               [UIFont systemFontOfSize:UI_LABEL_FONT_SIZE]

// 2. Bundle
// 2.1 取出main bundle中的资源的路径
#define ResourcePath(path)  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path]

// 2.2 根据指定路径从main bundle中加载生成无缓存的图片(UIImage)对象
#define ImageWithPath(path) [[UIImage alloc] initWithContentsOfFile:path]

/* 01和02可以组合使用
 * eg: UIImage *image = ImageWithPath(ResourcePath(@"abc/123.jpg"));
 * 以上代码，将main bundle的abc目录下的123.jpg生成了不缓存的UIImage对象
 */

// 3. 

#endif

