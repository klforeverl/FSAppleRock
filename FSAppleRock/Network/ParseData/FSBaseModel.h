//
//  FSBaseModel.h
//  FangStarFindHouse
//
//  Created by ZhangLan_PC on 16/7/8.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSBaseModel : NSObject

// 返回代码 1 成功 0 失败
@property (nonatomic, strong, readonly) NSString *result;
// 提示信息
@property (nonatomic, strong) NSString *msg;
// 错误代码
@property (nonatomic, strong) NSString *errorcode;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *dataString;

/**
 *  解析所有返回数据
 *
 *  @param jsonDictionary 返回的数据
 *  @param customInfo     解析时可自定义的信息
 */
- (void)parseAllNetResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

/**
 *  自动化解析业务数据
 *
 *  @param jsonDictionary data-json
 */
- (void)parseBusinessResult:(NSDictionary *)jsonDictionary forInfo:(id)customInfo;

@end
