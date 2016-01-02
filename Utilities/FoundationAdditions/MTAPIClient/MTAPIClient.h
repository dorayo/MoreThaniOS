//
//  MTAPIClient.h
//  NetServicesLayerDemo
//
//  Created by Dorayo on 15/12/31.
//  Copyright © 2015年 Dorayo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseURLStr @"http://afnetworking.sinaapp.com/"

typedef NS_ENUM(NSInteger) {
    GET = 0,
    POST,
    HEAD,
    PUT,
    DELETE
} NetworkMethod;

@interface MTAPIClient : NSObject

/**
 *  获取APIClient单例对象
 *
 *  @return MTAPIClient实例
 */
+ (instancetype)sharedAPIClient;

/**
 *  HTTP 数据请求（非 multipart/form-data）
 *
 *  @param method     NetworkMethod类型，GET/POST/HEAD/PUT/DELETE
 *  @param path       URI路径
 *  @param parameters 参数
 *  @param callback   void (^)(id responseObj, NSError *error)类型，是收到响应之后的回调处理。如果，成功，则error参数传nil;如果，失败，则responseObj参数传nil
 */
- (void)requestJSONDataWithMethod:(NetworkMethod)method
                             Path:(NSString *)path
                     parameters:(NSDictionary *)parameters
                       callback:(void (^)(id responseObj, NSError *error))callback;

/**
 *  HTTP multipart/form-data 数据请求
 *
 *  @param path       URI路径
 *  @param parameters 参数
 *  @param fileInfo   body中要携带的文件的信息  键有name/fileName/mimeType/image/等
 *  @param callback   void (^)(id responseObj, NSError *error)类型，是收到响应之后的回调处理。如果，成功，则error参数传nil;如果，失败，则responseObj参数传nil
 */
- (void)requestJSONDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)parameters
                       fileInfo:(NSDictionary *)fileInfo
                       callback:(void (^)(id responseObj, NSError *error))callback;

/**
 *  上传图片
 *
 *  @param image    将要上传的UIImage对象
 *  @param path     URI路径
 *  @param name     在body中image对象对应的键值
 *  @param callback void (^)(id responseObj, NSError *error)类型，是收到响应之后的回调处理。如果，成功，则error参数传nil;如果，失败，则responseObj参数传nil
 *  @param progress 上传过程中的进度回调，实现保证该代码块已经处于主线程，直接更新UI即可
 */
- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
           callback:(void(^)(id responseObj, NSError *error))callback
           progress:(void (^)(CGFloat progressValue))progress;

@end
