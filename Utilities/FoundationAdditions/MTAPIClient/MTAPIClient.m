//
//  MTAPIClient.m
//  NetServicesLayerDemo
//
//  Created by Dorayo on 15/12/31.
//  Copyright © 2015年 Dorayo. All rights reserved.
//

#import "MTAPIClient.h"
#import <AFHTTPSessionManager.h>

@interface MTAPIClient ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end


@implementation MTAPIClient

static MTAPIClient *_sharedClient;
static dispatch_once_t once;

+ (instancetype)sharedAPIClient {
    dispatch_once(&once, ^{
        _sharedClient = [[MTAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURLStr]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];

    // configration
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.manager.securityPolicy.allowInvalidCertificates = YES;
    
    return self;
}

#pragma mark - http(s) requests
- (NSString *)stringFromNetworkMethod:(NetworkMethod)method {
    switch (method) {
        case GET:
            return @"GET";
            break;
        case POST:
            return @"POST";
            break;
        case HEAD:
            return @"HEAD";
            break;
        case PUT:
            return @"PUT";
            break;
        case DELETE:
            return @"DELETE";
            break;
        default:
            return @"Unknown HTTP Method";
            break;
    }
}

- (void)requestJSONDataWithMethod:(NetworkMethod)method
                             Path:(NSString *)path
                     parameters:(NSDictionary *)parameters
                       callback:(void (^)(id, NSError *))callback {
    // 入参检查
    if (!path || path.length <= 0) {
        MTDebugLog(@"Path should not be null!");
        return;
    }
    
    // 入口调试Log
    MTDebugLog(@"\n===========request===========\n%@\n%@:\n%@", [self stringFromNetworkMethod:method], path, parameters);
    
    // 入参处理(URL)
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 发起请求
    switch (method) {
        case GET: {
            [self.manager GET:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                MTDebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                callback(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MTDebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                callback(nil, error);
            }];
            break;
        }
        case POST: {
            [self.manager POST:path parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                MTDebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                callback(responseObject, nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MTDebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                callback(nil, error);
            }];
            break;
        }
        case HEAD: {
            /**
             *  TODO:
             */
            break;
        }
        case PUT: {
            /**
             *  TODO:
             */
            break;
        }
        case DELETE: {
            /**
             *  TODO:
             */
            break;
        }
        default:
            break;
    }
}

- (void)requestJSONDataWithPath:(NSString *)path
                     parameters:(NSDictionary *)parameters
                       fileInfo:(NSDictionary *)fileInfo
                       callback:(void (^)(id, NSError *))callback {
    // 入参检查
    if (!path || path.length <= 0) {
        MTDebugLog(@"Path should not be null!");
        return;
    }
    
    if (!fileInfo) {
        MTDebugLog(@"FileInfo should not be null!");
        return;
    }
    
    // 入口调试Log
    MTDebugLog(@"\n===========request===========\n%@:\n%@", path, parameters);
    
    // 入参处理(URL)
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    // 取出fileInfo name/fileName/mimeType/image/...
    NSString *name = fileInfo[@"name"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSString *defaultFileName = [NSString stringWithFormat:@"%@.jpg", timestamp];
    NSString *fileName = fileInfo[@"fileName"] == nil ? defaultFileName : fileInfo[@"fileName"];
    
    NSString *defaultMIMEType = @"image/jpeg";
    NSString *mimeType = fileInfo[@"mimeType"] == nil ? defaultMIMEType : fileInfo[@"mimeType"];
    
    // 如果上传的是图片，可能需要对图片的大小进行压缩 (<= 5M)
    UIImage *image = fileInfo[@"image"];
    NSData *data;
    if (image) {
        data = UIImageJPEGRepresentation(image, 1.0);
        if ((float)data.length/1024/1024 > 5) {
            data = UIImageJPEGRepresentation(image, 1024*1024*5.0/(float)data.length);
        }
    }
    
    // 如果上传的是其他文件，则转换为NSData对象
    /*
     * TODO:
     */
    
    // 发起请求
    [self.manager POST:path parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MTDebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MTDebugLog(@"\n===========response===========\n%@:\n%@", path, error);
        callback(nil, error);
    }];
}

- (void)uploadImage:(UIImage *)image
               path:(NSString *)path
               name:(NSString *)name
           callback:(void(^)(id, NSError *))callback
           progress:(void (^)(CGFloat progressValue))progress {
    
    // 入参检查
    if (!path || path.length <= 0) {
        MTDebugLog(@"Path should not be null!");
        return;
    }

    if (!image) {
        MTDebugLog(@"Image should not be null!");
        return;
    }
    
    if (!name || name.length <= 0) {
        MTDebugLog(@"Name should not be null!");
        return;
    }
    
    // 入口调试Log
    MTDebugLog(@"\n===========upload image===========\n%@:\n%@", path, name);
    
    // 入参处理(URL)
    path = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    // 如果图片内容过大（>5M），则需要压缩
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if ((float)data.length/1024/1024 > 5) {
        data = UIImageJPEGRepresentation(image, 1024*1024*5.0/(float)data.length);
    }
    
    // 自动生成fileName
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timestamp = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", timestamp];
    MTDebugLog(@"\nUploadImage\n%@ : %.2fK", fileName, (float)data.length/1024);

    // 开始上传
    [self.manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress.fractionCompleted);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MTDebugLog(@"Success: %@", responseObject);
        callback(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MTDebugLog(@"Error: %@",error);
        callback(nil, error);
    }];
}


@end
