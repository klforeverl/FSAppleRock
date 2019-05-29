//
//  UILabel+FSUtility.h
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FSUtility)

/**
 *  创建Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *
 *  @return self
 */
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText;

/**
 *  创建Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *  @param textColor 颜色
 *
 *  @return self
 */
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor;

/**
 *  创建可换行Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *  @param textColor 颜色
 *
 *  @return self
 */
- (id)initMutiLinesLabelWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor;

/**
 *  创建Label
 *
 *  @param initFont  字体
 *  @param initText  文案
 *  @param textColor 颜色
 *  @param initTag   tag
 *
 *  @return self
 */
- (id)initWithFont:(UIFont *)initFont andText:(NSString *)initText andColor:(UIColor *)textColor withTag:(NSInteger)initTag;

/**
 *  创建Label(红色*）
 *
 *  @param initFont 字体
 *
 *  @return self
 */
- (id)initRedStart:(UIFont *)initFont;


/**
 *  设置行间距
 *
 *  @param lineSpacing 行间距
 */
- (void)setLineSpacing:(NSInteger)lineSpacing withString:(NSString *)withString;
/**
 *  设置行间距
 *
 *  @param lineSpacing   行间距
 *  @param withString    文本
 *  @param textAlignment 对齐方式
 */
- (void)setLineSpacing:(NSInteger)lineSpacing withString:(NSString *)withString textAlignment:(NSTextAlignment)textAlignment;

/**
 *  设置斜体
 */
- (void)setItalic;

@end
