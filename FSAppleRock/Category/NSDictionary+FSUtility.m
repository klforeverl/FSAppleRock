//
//  NSDictionary+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 2017/4/27.
//  Copyright © 2017年 fangstar.net. All rights reserved.
//

#import "NSDictionary+FSUtility.h"

@implementation NSDictionary (FSUtility)

- (instancetype)getSafeValueForKey:(NSString *)key
{
    id value;
    
    if ([[self allKeys] containsObject:key]) {
        value = [self objectForKey:key];
    }
    
    return value;
}
@end
