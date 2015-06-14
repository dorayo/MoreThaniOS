#ifndef COMMON_H
#define COMMON_H

// 封装NSLog
#ifdef DEBUG // 调试版本
#define YMLog(...) NSLog(__VA_ARGS__)
#else // 发布版本
#define YMLog(...) 
#endif

#endif
