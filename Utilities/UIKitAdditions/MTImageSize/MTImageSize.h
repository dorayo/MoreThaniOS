//
//  MTImageSize.h
//
//  Created by weiji.info on 14-31-10.
//  Copyright (c) 2014年 qingyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

extern char *const kPngRangeValue;
extern char *const kJpgRangeValue;
extern char *const kGifRangeValue;

CGSize pngImageSizeWithHeaderData(NSData *data);

CGSize jpgImageSizeWithHeaderData(NSData *data);

CGSize gifImageSizeWithHeaderData(NSData *data);


@interface MTImageSize : NSObject


//根据url获取图片大小
+(void)calculateImageSizeWithURLString:(NSString *)urlString success:(void (^)(CGSize imageSize))successHandler failure:(void(^)(NSError *error))failureHandler;

#ifdef SDWebImage
//使用SDWebImage的时候，根据url判断url的大小
+(CGSize)imageSizeForSDWWebImageWithURL:(NSURL *)url ;
#endif

@end