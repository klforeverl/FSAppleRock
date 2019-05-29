/****************************************************
 *Copyright (c) 2016 fangstar. All rights reserved.
 *FileName:     NSObject+ParseJSON.h
 *Author:       zhanglan
 *Date:         16/7/8.
 *Description:  JSON自动化解析：根据当前类的属性逐一去json中找，
 *              jsonValue：
 *              1、原子类型（非数组、字典）：直接给属性赋值；
 *              2、字典：
 *              3、数组：model中需要配置数据对应的model的名称
 *Others:
 *History:
 ****************************************************/
#import <Foundation/Foundation.h>
#define kModelPropertySuffix        @"_ObjectName"

@interface NSObject (FSParseJSON)

// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary;

// 自动解析Json
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson forInfo:(id)customInfo;

- (NSMutableString *)getJSONByModel;

/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryFromModel;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id)idFromObject:(nonnull id)object;
@end
