#ifndef COMMON_H
#define COMMON_H

// 00.封装NSLog
#ifdef DEBUG // 调试版本
#define MTLog(...) NSLog(__VA_ARGS__)
#else // 发布版本
#define MTLog(...) 
#endif

// 01.取出main bundle中的资源的路径
#define ResourcePath(path)  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path]

// 02.根据指定路径从main bundle中加载生成无缓存的图片(UIImage)对象
#define ImageWithPath(path) [[UIImage alloc] initWithContentsOfFile:path]
/* 01和02可以组合使用
 * eg: UIImage *image = ImageWithPath(ResourcePath(@"abc/123.jpg"));
 * 以上代码，将main bundle的abc目录下的123.jpg生成了不缓存的UIImage对象
 */

// 03.常用变量
#define MTDebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define kTipAlert(s, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(s), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define MTWeak(var, weakVar) __weak __typeof(&*var) weakVar = var
#define MTStrong_DoNotCheckNil(weakVar, _var) __typeof(&*weakVar) _var = weakVar
#define MTStrong(weakVar, _var) MTStrong_DoNotCheckNil(weakVar, _var); if (!_var) return;

#define MTWeak_(var) MTWeak(var, weak_##var);
#define MTStrong_(var) MTStrong(weak_##var, _##var);

/** defines a weak `self` named `__weakSelf` */
#define MTWeakSelf      MTWeak(self, __weakSelf);
/** defines a strong `self` named `_self` from `__weakSelf` */
#define MTStrongSelf    MTStrong(__weakSelf, _self);


#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

// 04.版本
#define kVersionCoding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define kVersionBuildCoding [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]

#endif
