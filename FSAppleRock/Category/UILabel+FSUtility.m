//
//  UILabel+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "UILabel+FSUtility.h"
#import "UIColor+FSUtility.h"
#import "NSString+FSUtility.h"

@implementation UILabel (FSUtility)

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:[UIColor colorFromHexValue:0x888888 alpha:1.0]];
        [self setFont:initFont];
        [self setText:initText];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }
    
    return self;
}

/**
 *  创建Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *  @param textColor 颜色
 *
 *  @return self
 */
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor
{
    if((self = [self initWithFrame:CGRectZero])) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:initText];
        [self setTextColor:textColor];
        
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }
    
    return self;
}

/**
 *  创建可换行Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *  @param textColor 颜色
 *
 *  @return self
 */
- (id)initMutiLinesLabelWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:initText];
        [self setTextColor:textColor];
        self.numberOfLines = 0;
        
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }
    
    return self;
}

// 创建Label
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor withTag:(NSInteger)initTag
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:initText];
        [self setTextColor:textColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [initText sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
        self.numberOfLines = 0;
        
        self.tag = initTag;
        
    }
    
    return self;
}

- (id)initRedStart:(UIFont *)initFont;
{
    if((self = [self initWithFrame:CGRectZero]) != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setFont:initFont];
        [self setText:@"*"];
        [self setTextColor:[UIColor redColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        CGSize labelSize = [@"*" sizeWithFontCompatible:initFont];
        [self setBounds:CGRectMake(0, 0, labelSize.width, labelSize.height)];
    }
    
    return self;
}

/**
 *  设置行间距
 *
 *  @param lineSpacing 行间距
 */
- (void)setLineSpacing:(NSInteger)lineSpacing withString:(NSString *)withString
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:withString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [withString length])];
    self.attributedText = attributedString;
    self.numberOfLines = 0;
}

/**
 *  设置行间距
 *
 *  @param lineSpacing   行间距
 *  @param withString    文本
 *  @param textAlignment 对齐方式
 */
- (void)setLineSpacing:(NSInteger)lineSpacing withString:(NSString *)withString textAlignment:(NSTextAlignment)textAlignment
{
    if (![withString isStringSafe]) {
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:withString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 调整行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setAlignment:textAlignment];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [withString length])];
    self.attributedText = attributedString;
    self.numberOfLines = 0;
}

/**
 *  设置斜体
 */
- (void)setItalic
{
    /** 斜体 **/
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
    self.transform = matrix;
}
@end
