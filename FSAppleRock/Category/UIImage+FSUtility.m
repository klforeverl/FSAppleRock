//
//  UIImage+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/12.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "UIImage+FSUtility.h"

@implementation UIImage (FSUtility)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
