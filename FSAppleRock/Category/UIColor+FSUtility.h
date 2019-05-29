//
//  UIColor+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FSUtility)

#pragma mark - 初始化颜色
+ (UIColor *)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(float)alpha;

+ (UIColor *)colorFromHexValue:(long)hexValue alpha:(float)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;

@end
