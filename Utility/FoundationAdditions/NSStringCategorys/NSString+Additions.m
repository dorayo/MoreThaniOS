//
//  NSString+Additions.m
//
//  Created by dorayo on 14/11/1.
//  Copyright (c) 2014年 dorayo.com. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

@end

@implementation NSString (URLEncode)

- (NSString *)urlStringByEncodeToPercentEscape
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)urlStringByDecodeFromPercentEscape
{
    NSMutableString *decodedString = [NSMutableString stringWithString:self];
    [decodedString replaceOccurrencesOfString:@"+"
                                   withString:@" "
                                      options:NSLiteralSearch
                                        range:NSMakeRange(0, [decodedString length])];
    
    return [decodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

@implementation NSString (DocumentPath)

+ (NSString *)pathStringByAppending:(NSString *)str
{
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [docPath stringByAppendingPathComponent:str];
}

@end

@implementation NSString (FileName)

- (NSString *)fileNameByAppend:(NSString *)append
{
    // 1. 获取不带扩展名的文件名
    NSString *baseName = [self stringByDeletingPathExtension];
    
    // 2. 在baseName上追加字符串
    baseName = [baseName stringByAppendingString:append];
    
    // 3. 取出扩展名
    NSString *extension = [self pathExtension];
    
    // 4. 拼接成新的文件名
    return [baseName stringByAppendingPathExtension:extension];
}

@end


