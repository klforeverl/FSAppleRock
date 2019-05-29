//
//  NSDictionary+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 2017/4/27.
//  Copyright © 2017年 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FSUtility)

- (instancetype)getSafeValueForKey:(NSString *)key;

@end
