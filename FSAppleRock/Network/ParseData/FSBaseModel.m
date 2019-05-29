//
//  FSBaseModel.m
//  FangStarFindHouse
//
//  Created by ZhangLan_PC on 16/7/8.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "FSBaseModel.h"
#import "NSObject+FSParseJSON.h"
#import "NSMutableDictionary+FSUtility.h"
#import "FSDataTypeConvert.h"

@implementation FSBaseModel

/**
 *  解析所有返回数据
 *
 *  @param jsonDictionary 返回的数据
 *  @param customInfo     解析时可自定义的信息
 */
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
    // ===================================================
    // 解析业务数据：区分data是数组、字段
    // ===================================================
    if ([[jsonDictionary objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionaryData = [jsonDictionary objectForKey:@"data"];
        
        if(dictionaryData && [dictionaryData isKindOfClass:[NSDictionary class]])
        {
            [self parseBusinessResult:dictionaryData forInfo:customInfo];
        }
    }
    
    // 数组
    else if ([[jsonDictionary objectForKey:@"data"] isKindOfClass:[NSArray class]])
    {
        // 将数组型的数据封装一层dictionary、统一解析
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObjectSafe:[jsonDictionary objectForKey:@"data"] forKey:@"data"];
        // 解析数据
        [self parseBusinessResult:dictionary forInfo:customInfo];
    }
    else if ([[jsonDictionary objectForKey:@"data"] isKindOfClass:[NSString class]]) {
        _dataString = [jsonDictionary objectForKey:@"data"];
    }
    else if ([[jsonDictionary objectForKey:@"data"] isKindOfClass:[NSNumber class]]) {
        _dataString = [[jsonDictionary objectForKey:@"data"] stringValue];
    }
    
    // ===================================================
    // 解析公共数据
    // ===================================================
    
    if ([[jsonDictionary allKeys] containsObject:@"result"])
    {
        _result = [FSDataTypeConvert allToString:[jsonDictionary objectForKey:@"result"]];
    }
    if ([[jsonDictionary allKeys] containsObject:@"msg"])
    {
        _msg = [FSDataTypeConvert allToString:[jsonDictionary objectForKey:@"msg"]];
    }
    if ([[jsonDictionary allKeys] containsObject:@"errorcode"])
    {
        _errorcode = [FSDataTypeConvert allToString:[jsonDictionary objectForKey:@"errorcode"]];
    }
    if ([[jsonDictionary allKeys] containsObject:@"code"])
    {
        _code = [FSDataTypeConvert allToString:[jsonDictionary objectForKey:@"code"]];
    }
}

/**
 *  自动化解析业务数据
 *
 *  @param jsonDictionary data-json
 *  @param customInfo
 */
- (void)parseBusinessResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo
{
    // 开始自动化解析
    [self parseJsonAutomatic:jsonDictionary forInfo:customInfo];
}
@end
