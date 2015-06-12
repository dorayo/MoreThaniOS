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
@end


