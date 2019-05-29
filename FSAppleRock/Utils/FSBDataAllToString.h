
/************************************************************************
 *Copyright (c) 2015 fangstar. All rights reserved.
 *FileName:     FSBDataAllToString.h
 *Author:       zhangbing
 *Date:         15/11/24
 *Description:  网络数据类型转字符串
 *Others:
 *History:
 ************************************************************************/
#import <Foundation/Foundation.h>

@interface FSBDataAllToString : NSObject

+ (NSString *)AllToString:(id)parameter;
+ (NSInteger )AllToInteger:(id)parameter;

@end
