//
//  String.m
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import "String.h"

@implementation String

+(NSMutableString*)replacingOccurrences:(NSMutableString*)str {
    [str replaceOccurrencesOfString:@"\"acg" withString:@"\"dj" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"\"cg" withString:@"\"dj" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"\"manga" withString:@"\"dj" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    return str;
}

+(NSMutableString*)replacingOccurrence:(NSString*)str {
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    str1 = [self replacingOccurrences:str1];
    return str1;
}

+(NSMutableString*)decode:(NSMutableString *)str {
    [str replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"&#39;" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    [str replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, str.length)];
    return str;
}

+(NSMutableString*)decodes:(NSString*)str {
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    str1 = [self decode:str1];
    return str1;
}

@end
