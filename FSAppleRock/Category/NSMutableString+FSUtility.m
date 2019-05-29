//
//  NSMutableString+FSUtility.m
//  FangStarBroker
//
//  Created by ZhangLan_PC on 2017/7/19.
//  Copyright © 2017年 fangstar. All rights reserved.
//

#import "NSMutableString+FSUtility.h"
#import "NSString+FSUtility.h"

@implementation NSMutableString (FSUtility)

- (void)appendSafeString:(NSString *)string;
{
    if ([string isStringSafe]) {
        [self appendString:string];
    }
}
@end
