//
//  FSSystem.h
//  FMLibrary
//
//  Created by fangstar on 13-4-24.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SvUDIDTools.h"

//判断是否是iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

typedef enum DeviceType {
    DeviceType_iPhone4s = 0,
    DeviceType_iPhone5 = 1,
    DeviceType_iPhone6 = 2,
    DeviceType_iPhone6plus = 3
} DeviceType;

@interface FSSystem : NSObject

//应用系统
+(NSString*)systemVersion;
+(CGFloat)versionFloatValue:(NSString*)versionString;
+(CGFloat)systemVersionFloat;
+ (BOOL)needUpdatewithNewVer:(NSString*)newVer oldVer:(NSString*)oldVer;

//设备
+ (NSString *)macAddress;
+ (NSString*)fmDeviceId;
+ (NSString *)fmDeviceIDFA;
+ (CGFloat)getOSVersion;
+ (BOOL)isIpad;
+ (BOOL)isIphone;
+ (BOOL)isJailbroken;
+ (NSString *) platformString;
+ (DeviceType) getDeviceType;

//网络
+ (NSString*)networkStatus;
+ (BOOL)connectedViaWiFi;
+ (BOOL)connectedVia3G;

//
+(CGSize)screenSize;
@end
