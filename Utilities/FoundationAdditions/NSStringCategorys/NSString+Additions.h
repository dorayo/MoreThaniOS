//
//  NSString+Additions.h
//
//  Created by dorayo on 14/11/1.
//  Copyright (c) 2014年 dorayo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

@end

@interface NSString (URLEncode)
- (NSString *)urlStringByEncodeToPercentEscape;
- (NSString *)urlStringByDecodeFromPercentEscape;
@end

@interface NSString (DocumentPath)
+ (NSString *)pathStringByAppending:(NSString *)str;
@end

@interface NSString (FileName)
- (NSString *)fileNameByAppend:(NSString *)append;

#pragma mark - Personal Infos Validation

// 手机号类型：移动、联通、电信、未知手机号
typedef NS_ENUM(NSInteger, MobilePhoneNumberType) {MobilePhoneNumberTypeCM=1, MobilePhoneNumberTypeCT, MobilePhoneNumberTypeCU, MobilePhoneNumberTypeUnknown=-1L};

@interface NSString (PersonalInfoValidation)
// 手机号
- (BOOL)isValidMobilePhoneNumber;
- (MobilePhoneNumberType)mobilePhoneNumberType;

// Email
- (BOOL)isValidEmailAddress;
@end

@end


