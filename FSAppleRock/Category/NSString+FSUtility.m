//
//  NSString+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "NSString+FSUtility.h"

#import <CommonCrypto/CommonHMAC.h>
#import "NSData+FSUtility.h"

@implementation NSString (FSUtility)
- (NSString *)getPureNumbers
{
    NSString *pureNumbers = [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    return pureNumbers;
}
/**
 *  判断字符串是否为空
 *
 */
- (BOOL)isStringSafe
{
    return [self length] > 0;
}

/**
 *  获取字符串MD5值
 *
 *  @return 小写MD5值
 */
- (NSString *)getMD5
{
    // 分配MD5结果空间
    uint8_t *md5Bytes = malloc(CC_MD5_DIGEST_LENGTH * sizeof(uint8_t));
    if(md5Bytes)
    {
        memset(md5Bytes, 0x0, CC_MD5_DIGEST_LENGTH);
        
        // 计算hash值
        NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
        CC_MD5((void *)[srcData bytes], (CC_LONG)[srcData length], md5Bytes);
        
        // 组建String
        NSMutableString* destString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            [destString appendFormat:@"%02X", md5Bytes[i]];
        }
        
        // 释放空间
        free(md5Bytes);
        
        // 返回小写字母的md5
        return [destString lowercaseString];
    }
    
    return nil;
}

#pragma mark 计算字符串size
/**
 *  计算字符串的size
 *
 *  @param font 字体
 *
 *  @return size
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font
{
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

/**
 *  计算字符串的size
 *
 *  @param font          字体
 *  @param width         最大宽度
 *  @param lineBreakMode
 *
 *  @return
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize size = [self sizeWithFontCompatible:font constrainedToSize:CGSizeMake(width, HUGE) lineBreakMode:lineBreakMode];
    return size;
}

/**
 *  计算字符串的size
 *
 *  @param font          字体
 *  @param size          最大size
 *  @param lineBreakMode
 *
 *  @return
 */
- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGSize result;
    if (!font)
        font = [UIFont systemFontOfSize:12];
    
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
    
    
    //    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES && font)
    //    {
    //        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
    //        CGRect stringRect = [self boundingRectWithSize:size
    //                                               options:NSStringDrawingUsesLineFragmentOrigin
    //                                            attributes:dictionaryAttributes
    //                                               context:nil];
    //        
    //        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    //    }
    //    else
    //    {
    //#pragma clang diagnostic push
    //#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    //        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    //#pragma clang diagnostic pop
    //    }
}

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawAtPoint:withAttributes:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawAtPoint:point withAttributes:dictionaryAttributes];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}


#pragma mark - New-计算size
- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode {
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}

- (CGFloat)widthForFont:(UIFont *)font {
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}
/**
 *  获取行数
 *
 *  @param font 字体
 *  @param size 显示范围
 *
 *  @return
 */
- (NSInteger)getRowCountWithFont:(UIFont *)font size:(CGSize)size
{
    NSInteger rowCount = 0;
    
    CGFloat totalHeight = [self heightForFont:font width:size.width];
    CGFloat oneRowHeight = [@"你好aaa" heightForFont:font width:size.width];
    
    rowCount = ceil(totalHeight/oneRowHeight);
    return rowCount;
}
/**
 *  计算高度
 *
 *  @param font           字体
 *  @param forLineSpacing 行间距
 *  @param size           显示范围
 *
 *  @return 高度
 */
- (CGFloat)heightForFont:(UIFont *)font
          forLineSpacing:(CGFloat)forLineSpacing
       constrainedToSize:(CGSize)size
{
    if (![self isStringSafe]) {
        return 0;
    }
    CGFloat totalHeight = [self heightForFont:font width:size.width];
    NSInteger rowCount = [self getRowCountWithFont:font size:size];
//    return totalHeight + forLineSpacing*(rowCount-1);
        return totalHeight + forLineSpacing*rowCount;
    
}

#pragma mark URLEncoding
- (NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    return result;
}

- (BOOL)containsString:(NSString *)contentString
{
    if ([self rangeOfString:contentString].location == NSNotFound) {
        return NO;
    }
    else {
        return YES;
    }
}

+ (NSString *)rand16String
{
    char data[16];
    for (int x=0;x<16;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *rand16Str = [[NSString alloc] initWithBytes:data length:16 encoding:NSUTF8StringEncoding];
    return [rand16Str lowercaseString];
}

+ (NSString *)rand32String
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *rand16Str = [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
    return [rand16Str lowercaseString];
}

- (NSString *)sha1String
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] sha1String];
}
@end
