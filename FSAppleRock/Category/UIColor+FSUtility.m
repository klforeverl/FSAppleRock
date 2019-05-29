//
//  UIColor+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "UIColor+FSUtility.h"

@implementation UIColor (FSUtility)

#pragma mark - 初始化颜色
+ (UIColor *)colorFromRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (UIColor *)colorFromHexValue:(long)hexValue alpha:(float)alpha
{
    return [UIColor \
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
            blue:((float)(hexValue & 0x0000FF))/255.0 \
            alpha:alpha];
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 判断前缀并剪切掉
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}
@end
