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

- (NSString *)stringByEncodeToPercentEscape
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)stringByDecodeFromPercentEscape
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

