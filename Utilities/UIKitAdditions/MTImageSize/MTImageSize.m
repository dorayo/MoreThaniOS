//
//  MTImageSize.h
//
//  Created by weiji.info on 14-31-10.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//


#import "MTImageSize.h"


typedef NS_ENUM(NSUInteger, ImageType) {
    ImageTypePNG,
    ImageTypeJPG,
    ImageTypeGIF,
    ImageTypeCount
};

#define kPNGRangeValue  "bytes=16-23"
#define kJPGRangeValue  "bytes=0-209"
#define kGIFRangeValue  "bytes=6-9"

const char *kImageRangeValues[ImageTypeCount] = {kPNGRangeValue, kJPGRangeValue, kGIFRangeValue};



CGSize pngImageSizeWithHeaderData(NSData *data)
{
    int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
    [data getBytes:&w1 range:NSMakeRange(0, 1)];
    [data getBytes:&w2 range:NSMakeRange(1, 1)];
    [data getBytes:&w3 range:NSMakeRange(2, 1)];
    [data getBytes:&w4 range:NSMakeRange(3, 1)];
    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
    
    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
    [data getBytes:&h1 range:NSMakeRange(4, 1)];
    [data getBytes:&h2 range:NSMakeRange(5, 1)];
    [data getBytes:&h3 range:NSMakeRange(6, 1)];
    [data getBytes:&h4 range:NSMakeRange(7, 1)];
    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
    
    return CGSizeMake(w, h);
}

static inline CGSize jpgImageSizeWithExactData(NSData *data)
{
    short w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(2, 1)];
    [data getBytes:&w2 range:NSMakeRange(3, 1)];
    short w = (w1 << 8) + w2;
    
    short h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(0, 1)];
    [data getBytes:&h2 range:NSMakeRange(1, 1)];
    short h = (h1 << 8) + h2;
    
    return CGSizeMake(w, h);
}

CGSize jpgImageSizeWithHeaderData(NSData *data)
{
#ifdef DEBUG
    // @"bytes=0-209"
    assert([data length] == 210);
#endif
    short word = 0x0;
    [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
    if (word == 0xdb) {
        [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
        if (word == 0xdb) {
            // 两个DQT字段
            NSData *exactData = [data subdataWithRange:NSMakeRange(0xa3, 0x4)];
            return jpgImageSizeWithExactData(exactData);
        } else {
            // 一个DQT字段
            NSData *exactData = [data subdataWithRange:NSMakeRange(0x5e, 0x4)];
            return jpgImageSizeWithExactData(exactData);
        }
    } else {
        return CGSizeZero;
    }
}

CGSize gifImageSizeWithHeaderData(NSData *data)
{
    short w1 = 0, w2 = 0;
    [data getBytes:&w1 range:NSMakeRange(1, 1)];
    [data getBytes:&w2 range:NSMakeRange(0, 1)];
    short w = (w1 << 8) + w2;
    
    short h1 = 0, h2 = 0;
    [data getBytes:&h1 range:NSMakeRange(3, 1)];
    [data getBytes:&h2 range:NSMakeRange(2, 1)];
    short h = (h1 << 8) + h2;
    
    return CGSizeMake(w, h);
}


@implementation MTImageSize

+(void)calculateImageSizeWithURLString:(NSString *)urlString success:(void (^)(CGSize imageSize))successHandler failure:(void(^)(NSError *error))failureHandler{
    
    NSURL *imageUrl = [NSURL URLWithString:urlString];
    NSArray *types = @[@".png", @".jpg", @".gif"];
    int type = 0;
    NSString *rangeValue;
    __block CGSize imageSize  = CGSizeZero;
    
    if (urlString == nil || imageUrl == nil) {
        NSError *error = [NSError errorWithDomain:@"ImageSizeErrorDomain" code:101 userInfo:@{NSLocalizedDescriptionKey:@"url error!"}];
        failureHandler(error);
        return;
    }
    
    //确定类型
    for (int i =  0; i < types.count; i++) {
        NSRange range = [urlString rangeOfString:types[i]];
        if (range.length != 0) {
            type = i;
            rangeValue = [NSString stringWithUTF8String:kImageRangeValues[i]];
            break;
        }
    }
    
    if (!rangeValue) {
        NSError *error = [NSError errorWithDomain:@"ImageSizeErrorDomain" code:102 userInfo:@{NSLocalizedDescriptionKey:@"not found image!"}];
        failureHandler(error);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:imageUrl];
        [request setValue:rangeValue forHTTPHeaderField:@"Range"];
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        // 失败
        if (error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failureHandler(error);
            });
            return;
        }
        
        // 成功
        switch (type) {
            case ImageTypePNG:
            {
                imageSize = pngImageSizeWithHeaderData(data);
            }
                break;
            case ImageTypeJPG:
            {
                imageSize = jpgImageSizeWithExactData(data);
            }
                break;
            case ImageTypeGIF:
            {
                imageSize = gifImageSizeWithHeaderData(data);
            }
                break;
                
            default:
                break;
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            successHandler(imageSize);
        });
    });
}

@end
