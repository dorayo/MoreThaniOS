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

#pragma mark - Personal Infos Validation
@implementation NSString (PersonalInfoValidation)

+(BOOL)isMatchesRegularExpression:(NSString *)string byExpression:(NSString *)regex

{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:string];
    
}


- (BOOL)isValidMobilePhoneNumber
{
    NSString *mobileRegex =  @"^1(3[0-9]|4[57]|5[0-35-9]|7[78]|8[0-9])\\d{8}$";
    
    return [NSString isMatchesRegularExpression:self byExpression:mobileRegex];
}

- (MobilePhoneNumberType)mobilePhoneNumberType
{
    NSString *CMRegex = @"^1(34[0-8]|(3[5-9]|47|5[0-27-9]|78|8[2-478])[0-9])[0-9]{7}$";
    NSString *CURegex = @"^1(3[0-2]|45|5[56]|76|8[56])[0-9]{8}$";
    
    if (![NSString isMatchesRegularExpression:self byExpression:CMRegex]) {
        NSLog(@"Unkown Mobile Phone Number Type!");
        return MobilePhoneNumberTypeUnknown;
    }
    
    MobilePhoneNumberType type = MobilePhoneNumberTypeUnknown;
    
    if ([NSString isMatchesRegularExpression:self byExpression:CMRegex]) {
        NSLog(@"China Mobile");
        type = MobilePhoneNumberTypeCM;
    } else if ([NSString isMatchesRegularExpression:self byExpression:CURegex]) {
        NSLog(@"China Unicom");
        type = MobilePhoneNumberTypeCU;
    } else {
        NSLog(@"China Telecom");
        type = MobilePhoneNumberTypeCT;
    }
    
    return type;
}

- (BOOL)isValidEmailAddress
{
    NSString *emailRegex = @"[A-Za-z0-9._%+-]{3,}@[A-Za-z0-9.-]+\\.[A-Za-z]+";
    return [NSString isMatchesRegularExpression:self byExpression:emailRegex];
}

@end



