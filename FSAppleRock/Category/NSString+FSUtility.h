//
//  NSString+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (FSUtility)

- (NSString *)getPureNumbers;

/**
 *  判断字符串是否为空
 *
 */
- (BOOL)isStringSafe;

/**
 *  获取字符串的MD5值
 *
 *  @return MD5值（小写）
 */
- (NSString * _Nullable )getMD5;

#pragma mark - 计算size
/**
 *  计算字符串的size
 *
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeWithFontCompatible:(UIFont *_Nullable)font;

/**
 计算字符串的size

 @param font 字体
 @param width 最大宽度
 @param lineBreakMode 行终止模式
 @return size
 */
- (CGSize)sizeWithFontCompatible:(UIFont * _Nullable)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  计算字符串的size
 *
 *  @param font          字体
 *  @param size          最大size
 *
 *  @return size
 */
- (CGSize)sizeWithFontCompatible:(UIFont * _Nullable)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;


#pragma mark - New计算size
/**
 *  获取行数
 *
 *  @param font 字体
 *  @param size 显示范围
 *
 */
- (NSInteger)getRowCountWithFont:(UIFont * _Nullable)font size:(CGSize)size;

- (CGFloat)widthForFont:(UIFont * _Nullable)font;

- (CGFloat)heightForFont:(UIFont * _Nullable)font width:(CGFloat)width;

/**
 *  计算高度
 *
 *  @param font           字体
 *  @param forLineSpacing 行间距
 *  @param size           显示范围
 *
 *  @return 高度
 */
- (CGFloat)heightForFont:(UIFont *_Nullable)font
          forLineSpacing:(CGFloat)forLineSpacing
       constrainedToSize:(CGSize)size;

// URLEncoding
- (NSString *_Nullable)URLEncodedString;
- (NSString *_Nullable)URLDecodedString;

- (BOOL)containsString:(NSString *_Nullable)contentString;

/**
 Returns a lowercase NSString for 16 bit char
 */
+ (NSString *_Nullable)rand16String;

/**
 Returns a lowercase NSString for 32 bit char
 */
+ (NSString *_Nullable)rand32String;

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (nullable NSString *)sha1String;

@end
