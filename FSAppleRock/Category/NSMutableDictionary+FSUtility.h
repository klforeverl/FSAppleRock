//
//  NSMutableDictionary+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (FSUtility)

/**
 *  设置key/value
 *
 *  @param anObject value
 *  @param aKey     key
 */
- (void)setObjectSafe:(id)anObject forKey:(id < NSCopying >)aKey;

- (id)objectForKeySafe:(id < NSCopying >)aKey;

@end
