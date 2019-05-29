//
//  UIColor+Extention.h
//  FSLibrary
//
//  Created by XuLei on 15/8/25.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extention)

+ (UIColor *)ColorFromRed:(NSInteger)red Green:(NSInteger)green Blue:(NSInteger)blue Alpha:(float)alpha;

+ (UIColor *)ColorFromHexValue:(long)hexValue Alpha:(float)alpha;
@end
