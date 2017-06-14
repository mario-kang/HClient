//
//  String.h
//  HClient
//
//  Created by 강희찬 on 2017. 6. 10..
//  Copyright © 2017년 mario-kang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface String : NSObject

+(NSMutableString*)replacingOccurrences:(NSMutableString*)str;
+(NSMutableString*)replacingOccurrence:(NSString*)str;
+(NSMutableString*)decode:(NSMutableString*)str;
+(NSMutableString*)decodes:(NSString*)str;

@end
