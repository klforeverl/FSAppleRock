//
//  FMUImage.h
//  FMLibrary
//
//  Created by fangstar on 13-4-16.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#define FMUIMAGE_SCALE_TYPE_FITMAX 0
#define FMUIMAGE_SCALE_TYPE_FITMIN 1

/**
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
 */
#define FMCOLOR_FROM_RGB(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

/**
 Create a UIColor with an alpha value from a hex value.
 
 For example, `UIColorFromRGBA(0xFF0000, .5)` creates a `UIColor` object
 representing a half-transparent red.
 */
#define FMCOLOR_FROM_HEXA(hexValue, alpha) \
[UIColor \
colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alpha]


@interface FMUImage : NSObject

+(UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize SourceImage:(UIImage*)sourceImage CropType:(NSUInteger)cropType;
+ (UIImage*) createRoundedRectImage:(UIImage*)image cornerPercent:(CGFloat)cornerPercent;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIColor *) colorWithHexString:(NSString *)color;

@end
