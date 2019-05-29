//
//  NSObject+FSParseJSON.m
//  FangStarFindHouse
//
//  Created by ZhangLan_PC on 16/7/8.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "NSObject+FSParseJSON.h"

#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>

#import "FSBaseModel.h"

#import "NSString+FSUtility.h"

// ===================================================
// 注意：解析json，如果数据类型是arry，需要配置array里面存放的
// model对应的类名称（配置在各个model的属性中，属性的命名：
// array对应的属性名称+后缀_ObjectName
// ===================================================

@implementation NSObject (FSParseJSON)

// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        if(iVar == nil)
        {
            // 采用另外一种方法尝试获取
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 赋值
        if(iVar != nil)
        {
            id propertyValue = object_getIvar(self, iVar);
            
            // 插入Dictionary中
            if(propertyValue != nil)
            {
                [dictionary setObject:propertyValue forKey:propertyName];
            }
        }
    }
    
    free(properties);
}


//
/**
 *  自动化解析Json
 *
 *  @param dictionaryJson 待解析的json
 *  @param customInfo     自定义信息
 */
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson forInfo:(id)customInfo
{
    // 如果Json数据无效,产生Json
    if(dictionaryJson == nil)
    {
        dictionaryJson = [[NSDictionary alloc] init];
    }
    
    // 获取对象
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取propertys
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        // 获取property
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        // 获取Var
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
        
        if(iVar == nil)
        {
            iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
        }
        
        // 获取Name
        if((iVar != nil) && (![dictionaryJson isEqual:[NSNull null]]))
        {
            id jsonValue = [dictionaryJson objectForKey:propertyName];
            
            // ===================================================
            // jsonValue为dictionary对象
            // ===================================================
            if(([jsonValue isKindOfClass:[NSDictionary class]]) || ([jsonValue isKindOfClass:[NSMutableDictionary class]]))
            {
                // ===================================================
                // 获取jsonValue对应的实体model
                // ===================================================
                const char * propertyType = property_getAttributes(property);
                NSString *propertyTypeString = [[NSString alloc] initWithUTF8String:propertyType];
                NSArray *separtorArray = [propertyTypeString componentsSeparatedByString:@"\""];
                // 取model类名
                NSString *modelClassName;
                if (separtorArray.count > 1)
                {
                    modelClassName = separtorArray[1];
                }
                
                // ===================================================
                // 初始化model，并递归解析
                // ===================================================
                if (modelClassName && [modelClassName isStringSafe] && ![modelClassName isEqualToString:@"NSDictionary"] && ![modelClassName isEqualToString:@"NSMutableDictionary"])
                {
                    Class varClass = NSClassFromString(modelClassName);
                    
                    id varObject = [[varClass alloc] init];
                    
                    // 进行自定义解析
                    if((varObject != nil) && ([varObject respondsToSelector:@selector(parseBusinessResult:forInfo:)]))
                    {
                        [varObject parseBusinessResult:jsonValue forInfo:customInfo];
                    }
                    // 递归进行下层解析
                    else
                    {
                        [varObject parseJsonAutomatic:jsonValue forInfo:customInfo];
                    }
                    
                    // 赋值
                    object_setIvar(self, iVar, varObject);
                }
                // ---------------------------------
                // 赋给dictionary类型
                // ---------------------------------
                else
                {
                    // 赋值
                    object_setIvar(self, iVar, jsonValue);
                }
            }
            
            // ===================================================
            // jsonValue为array对象
            // ===================================================
            
            else if([jsonValue isKindOfClass:[NSArray class]] || ([jsonValue isKindOfClass:[NSMutableArray class]]))
            {
                // ===================================================
                // 取array元素对应的实体（实体类，配置在当前model中）
                // ===================================================
                NSString *classNameProperty = [NSString stringWithFormat:@"%@%@", propertyName, kModelPropertySuffix];
                
                Ivar classIvar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", classNameProperty] UTF8String]);
                
                // array元素对应的实体类名
                NSString *varType = object_getIvar(self, classIvar);
                
                if(varType != nil)
                {
                    NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
                    
                    // 基本数据类型
                    if(([varType isEqualToString:@"NSString"]) || ([varType isEqualToString:@"NSNumber"]))
                    {
                        [arrayDest addObjectsFromArray:jsonValue];
                    }
                    else
                    {
                        // 初始化实体类
                        Class varClass = NSClassFromString(varType);
                        
                        // 解析
                        NSInteger jsonCount = [jsonValue count];
                        for(NSInteger i = 0; i < jsonCount; i++)
                        {
                            id item = [jsonValue objectAtIndex:i];
                            
                            if ([item isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary *dictionaryJsonItem = item;
                                if(dictionaryJsonItem != nil)
                                {
                                    id varObject = [[varClass alloc] init];
                                    
                                    // 进行自定义解析
                                    if((varObject) && ([varObject respondsToSelector:@selector(parseBusinessResult:forInfo:)]))
                                    {
                                        [varObject parseBusinessResult:dictionaryJsonItem forInfo:customInfo];
                                    }
                                    // 递归进行下层解析
                                    else
                                    {
                                        [varObject parseJsonAutomatic:dictionaryJsonItem forInfo:customInfo];
                                    }
                                    if (varObject) {
                                        [arrayDest addObject:varObject];
                                    }
                                }
                            }
                            else if ([item isKindOfClass:[NSArray class]])
                            {
                                NSArray *arrayJsonItem = item;
                                if(arrayJsonItem != nil)
                                {
                                    id varObject = [[varClass alloc] init];
                                    
                                    // 进行自定义解析
                                    if((varObject != nil) && ([varObject respondsToSelector:@selector(parseBusinessResult:forInfo:)]))
                                    {
                                        //                                        [varObject parseBusinessResult:arrayJsonItem forInfo:customInfo];
                                    }
                                    // 递归进行下层解析
                                    else
                                    {
                                        varObject = [NSObject parseJsonArrayAutomatic:item
                                                                      withObjectClass:varClass
                                                                              forInfo:customInfo];
                                    }
                                    
                                    [arrayDest addObject:varObject];
                                }
                            }
                        }
                    }
                    
                    // 赋值
                    object_setIvar(self, iVar, arrayDest);
                }
                // 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
                else
                {
                    const char * propertyType = property_getAttributes(property);
                    NSString *propertyTypeString = [[NSString alloc] initWithUTF8String:propertyType];
                    NSArray *separtorArray = [propertyTypeString componentsSeparatedByString:@"\""];
                    // 取model类名
                    NSString *modelClassName;
                    if (separtorArray.count > 1) {
                        modelClassName = separtorArray[1];
                    }
                    if ([modelClassName isEqualToString:@"NSArray"] || [modelClassName isEqualToString:@"NSMutableArray"]) {
                        // 赋值
                        object_setIvar(self, iVar, jsonValue);
                    }
                }
            }
            else if ([jsonValue isKindOfClass:[NSNull class]] || !jsonValue)
            {
                // 空对象，不进行处理，让对象继续保持为nil
            }
            /** NSNumber直接转为NSString **/
            else if ([jsonValue isKindOfClass:[NSNumber class]])
            {
                NSString *stringValue = [(NSNumber *)jsonValue stringValue];
                
                // ===================================================
                // 判断model里面属性的类型是否是string，是才进行赋值
                // ===================================================
                const char * propertyType = property_getAttributes(property);
                NSString *propertyTypeString = [[NSString alloc] initWithUTF8String:propertyType];
                NSArray *separtorArray = [propertyTypeString componentsSeparatedByString:@"\""];
                // 取model类名
                NSString *modelClassName;
                if (separtorArray.count > 1) {
                    modelClassName = separtorArray[1];
                }
                if ([modelClassName isEqualToString:@"NSString"] || [modelClassName isEqualToString:@"NSMutableString"]) {
                    // 赋值
                    if ([stringValue isStringSafe]) {
                        object_setIvar(self, iVar, stringValue);
                    }
                }
            }
#pragma mark - 修改，json为string类型，判断model里面定义的是否是string，是才赋值
            // 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
            else {
                const char * propertyType = property_getAttributes(property);
                NSString *propertyTypeString = [[NSString alloc] initWithUTF8String:propertyType];
                NSArray *separtorArray = [propertyTypeString componentsSeparatedByString:@"\""];
                // 取model类名
                NSString *modelClassName;
                if (separtorArray.count > 1) {
                    modelClassName = separtorArray[1];
                }
                if ([modelClassName isEqualToString:@"NSString"] || [modelClassName isEqualToString:@"NSMutableString"]) {
                    if ([jsonValue isKindOfClass:[NSString class]] || [jsonValue isKindOfClass:[NSMutableString class]]) {
                        object_setIvar(self, iVar, jsonValue);
                    }
                }
                
            }
        }
    }
    free(properties);
}

//
/**
 *  自动解析JsonArray
 *
 *  @param arrayJson   array-json
 *  @param objectClass array-ModelClass
 *  @param customInfo
 *
 *  @return 解析后的数组
 */

+ (NSArray *)parseJsonArrayAutomatic:(NSArray *)arrayJson withObjectClass:(Class)objectClass forInfo:(id)customInfo
{
    // 如果Json数据无效,产生Sentry Json
    if(arrayJson == nil)
    {
        arrayJson = [[NSArray alloc] init];
    }
    
    NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
    
    const char *cClassName = class_getName(objectClass);
    NSString *className = [NSString stringWithUTF8String:cClassName];
    
    // 基本数据类型
    if(([className isEqualToString:@"NSString"]) || ([className isEqualToString:@"NSNumber"]))
    {
        [arrayDest addObjectsFromArray:arrayJson];
    }
    else
    {
        // 解析
        NSInteger jsonCount = [arrayJson count];
        for(NSInteger i = 0; i < jsonCount; i++)
        {
            NSDictionary *dictionaryJson = [arrayJson objectAtIndex:i];
            if(dictionaryJson != nil)
            {
                id varObject = [[objectClass alloc] init];
                
                // 进行自定义解析
                if((varObject != nil) && ([varObject respondsToSelector:@selector(parseBusinessResult:forInfo:)]))
                {
                    [varObject parseBusinessResult:dictionaryJson forInfo:customInfo];
                }
                // 递归进行下层解析
                else
                {
                    [varObject parseJsonAutomatic:dictionaryJson forInfo:customInfo];
                }
                
                [arrayDest addObject:varObject];
            }
        }
    }
    
    return arrayDest;
}

- (NSMutableString *)getJSONByModel
{
    NSMutableString *jsonString = [[NSMutableString alloc] init];
    
    // 获取对象
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取propertys
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        // 获取property
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        if ([propertyName containsString:kModelPropertySuffix]) {
            continue;
        }
        NSString *propertyItem = [NSString stringWithFormat:@"\"%@\":\"%@\"", propertyName, propertyName];
        
        [jsonString appendString:propertyItem];
        
        // 只有最后一项有','号
        if (i != propertyCount-1)
        {
            [jsonString appendString:@","];
        }
    }
    
    return jsonString;
}

- (NSDictionary *)dictionaryFromModel
{
    unsigned int count = 0;
    
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [self valueForKey:key];
        
        //only add it to dictionary if it is not nil
        if (key && value) {
            if ([value isKindOfClass:[NSString class]]
                || [value isKindOfClass:[NSNumber class]]) {
                // 普通类型的直接变成字典的值
                [dict setObject:value forKey:key];
            }
            else if ([value isKindOfClass:[NSArray class]]
                     || [value isKindOfClass:[NSDictionary class]]) {
                // 数组类型或字典类型
                [dict setObject:[self idFromObject:value] forKey:key];
            }
            else {
                // 如果model里有其他自定义模型，则递归将其转换为字典
                [dict setObject:[value dictionaryFromModel] forKey:key];
            }
        } else if (key && value == nil) {
            // 如果当前对象该值为空，设为nil。在字典中直接加nil会抛异常，需要加NSNull对象
            [dict setObject:[NSNull null] forKey:key];
        }
    }
    
    free(properties);
    return dict;
}

- (id)idFromObject:(nonnull id)object
{
    if ([object isKindOfClass:[NSArray class]]) {
        if (object != nil && [object count] > 0) {
            NSMutableArray *array = [NSMutableArray array];
            for (id obj in object) {
                // 基本类型直接添加
                if ([obj isKindOfClass:[NSString class]]
                    || [obj isKindOfClass:[NSNumber class]]) {
                    [array addObject:obj];
                }
                // 字典或数组需递归处理
                else if ([obj isKindOfClass:[NSDictionary class]]
                         || [obj isKindOfClass:[NSArray class]]) {
                    [array addObject:[self idFromObject:obj]];
                }
                // model转化为字典
                else {
                    [array addObject:[obj dictionaryFromModel]];
                }
            }
            return array;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        if (object && [[object allKeys] count] > 0) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (NSString *key in [object allKeys]) {
                // 基本类型直接添加
                if ([object[key] isKindOfClass:[NSNumber class]]
                    || [object[key] isKindOfClass:[NSString class]]) {
                    [dic setObject:object[key] forKey:key];
                }
                // 字典或数组需递归处理
                else if ([object[key] isKindOfClass:[NSArray class]]
                         || [object[key] isKindOfClass:[NSDictionary class]]) {
                    [dic setObject:[self idFromObject:object[key]] forKey:key];
                }
                // model转化为字典
                else {
                    [dic setObject:[object[key] dictionaryFromModel] forKey:key];
                }
            }
            return dic;
        }
        else {
            return object ? : [NSNull null];
        }
    }
    
    return [NSNull null];
}
@end

