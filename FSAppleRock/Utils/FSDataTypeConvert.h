
/************************************************************************
 *Copyright (c) 2015 fangstar. All rights reserved.
 *FileName:     FSBDataAllToString.h
 *Author:       zhangbing
 *Date:         15/11/24
 *Description:  数据类型转换
 *Others:
 *History:
 ************************************************************************/
#import <Foundation/Foundation.h>

@interface FSDataTypeConvert : NSObject

+ (NSString *)allToString:(id)parameter;
+ (NSInteger )allToInteger:(id)parameter;

@end
