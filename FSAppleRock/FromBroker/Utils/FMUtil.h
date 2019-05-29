//
//  FMUtil.h
//  FMLibrary
//
//  Created by fangstar on 13-3-22.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMUImage.h"
#import "FMUString.h"
#import "FMUMath.h"
#import "FMUTestData.h"
#import "FSSystem.h"
#import "FMUICreator.h"

//Alert用
#define DEFAULT_OKSTR @"确定"
#define ALERT4(title, msg, cstr, delg)\
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delg cancelButtonTitle:cstr otherButtonTitles:nil];\
[alert show];\
[alert release];}

#define ALERT3(title, msg, cstr)\
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:cstr otherButtonTitles:nil];\
[alert show];\
[alert release];}

#define ALERT2(title, msg)\
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:DEFAULT_OKSTR otherButtonTitles:nil];\
[alert show];\
[alert release];}

#define ALERT1(msg)\
{UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:DEFAULT_OKSTR otherButtonTitles:nil];\
[alert show];\
[alert release];}

//Bean用
#define DICT_ASSIGN3(pname, dict, key)\
if ([dict objectForKey:key] && !([dict objectForKey:key] == [NSNull null])) {\
self.pname = [NSString stringWithFormat:@"%@", [dict objectForKey:key]];\
}\
else {\
self.pname = @"";\
}

#define DICT_ASSIGN2(pname, dict)\
if ([dict objectForKey:@#pname] && !([dict objectForKey:@#pname] == [NSNull null])) {\
self.pname = [NSString stringWithFormat:@"%@", [dict objectForKey:@#pname]];\
}\
else {\
self.pname = @"";\
}

#define DICT_ASSIGN1(pname)\
if ([dict objectForKey:@#pname] && !([dict objectForKey:@#pname] == [NSNull null])) {\
self.pname = [NSString stringWithFormat:@"%@", [dict objectForKey:@#pname]];\
}\
else {\
self.pname = @"";\
}

#define DICT_EXPORT3(pname, md, exname)\
if(pname) [md setObject:pname forKey:exname];

#define DICT_EXPORT2(pname, md)\
if(pname) [md setObject:pname forKey:@#pname];

#define DICT_EXPORT1(pname)\
if(pname) [md setObject:pname forKey:@#pname];

//基本设置
#define USER_DEFAULTS_GET(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define USER_DEFAULTS_SAVE(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]

#define USER_DEFAULTS_REMOVE(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

@interface FMUtil : NSObject

@end
