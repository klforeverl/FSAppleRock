//
//  NSMutableDictionary+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "NSMutableDictionary+FSUtility.h"

@implementation NSMutableDictionary (FSUtility)

/**
 *  设置key/value
 *
 *  @param anObject value
 *  @param aKey     key
 */
- (void)setObjectSafe:(id)anObject forKey:(id < NSCopying >)aKey
{
    if(anObject != nil)
    {
        [self setObject:anObject forKey:aKey];
    }
    else
    {
        if ([self objectForKey:aKey])
        {
            [self removeObjectForKey:aKey];
        }
    }
}

- (id)objectForKeySafe:(id < NSCopying >)aKey
{
    if ([[self allKeys] containsObject:aKey]) {
        return [self objectForKey:aKey];
    }
    else {
        return nil;
    }
}
@end
