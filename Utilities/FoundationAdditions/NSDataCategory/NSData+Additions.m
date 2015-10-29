//
//  NSData+Additions.m
//
//  Created by dorayo on 15/10/29.
//  Copyright © 2015年 dorayo. All rights reserved.
//

#import "NSData+Additions.h"

@implementation NSData (Additions)

static int hexChar2int(char c)
{
    int value = c;
    if (isalpha(c)) {
        char lowerC = tolower(c);
        value = 10 + (lowerC - 'a');
    } else {
        value = atoi(&c);
    }
    
    return value;
}

static int decimalValue(NSString *string)
{
    char c1 = (char)[string characterAtIndex:0];
    char c2 = (char)[string characterAtIndex:1];
    
    int result = 0;
    result = hexChar2int(c1) * 16 + hexChar2int(c2);
    return result;
}

+ (NSData *)dataFromHexString:(NSString *)hexStr
{
    if (hexStr.length % 2) {
        NSLog(@"Error: String Format");
        return nil;
    }
    
    int count = (int)hexStr.length/2;
    char hexDataArr[count];
    
    for (int i = 0; i < count; i++) {
        NSRange range = NSMakeRange(i*2, 2);
        NSString *subStr = [hexStr substringWithRange:range];
        hexDataArr[i] = decimalValue(subStr);
    }
    
    NSData *data = [NSData dataWithBytes:hexDataArr length:count];
    return data;
}

@end
