//
//  UIColor+Extention.m
//  FSLibrary
//
//  Created by XuLei on 15/8/25.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import "UIColor+Extention.h"

@implementation UIColor (Extention)

+ (UIColor *)ColorFromRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue Alpha:(float)alpha
{
    return [UIColor colorWithRed:red/255.f green:green/255.f blue:blue/255.f alpha:alpha];
}

+ (UIColor *)ColorFromHexValue:(long)hexValue Alpha:(float)alpha
{
    return [UIColor \
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
            green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
            blue:((float)(hexValue & 0x0000FF))/255.0 \
            alpha:alpha];
}
@end
