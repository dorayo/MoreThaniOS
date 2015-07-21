#ifndef COMMON_H
#define COMMON_H

// 00.封装NSLog
#ifdef DEBUG // 调试版本
#define YMLog(...) NSLog(__VA_ARGS__)
#else // 发布版本
#define YMLog(...) 
#endif

// 01.取出main bundle中的资源的路径
#define ResourcePath(path)  [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path]

// 02.根据指定路径从main bundle中加载生成无缓存的图片(UIImage)对象
#define ImageWithPath(path) [[UIImage alloc] initWithContentsOfFile:path]
/* 01和02可以组合使用
 * eg: UIImage *image = ImageWithPath(ResourcePath(@"abc/123.jpg"));
 * 以上代码，将main bundle的abc目录下的123.jpg生成了不缓存的UIImage对象
 */

// 03.屏幕宽度、高度宏
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


#endif
