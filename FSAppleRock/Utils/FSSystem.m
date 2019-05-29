//
//  FSSystem.m
//  FMLibrary
//
//  Created by fangstar on 13-4-24.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FSSystem.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <sys/utsname.h>
#import "OpenUDID.h"
#import "OpenUDID+Keychain.h"

#import "Reachability.h"
#import <AdSupport/AdSupport.h>

@implementation FSSystem

#pragma mark - 应用系统
//应用版本
+(NSString*)systemVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//应用版本号（float值）
+(CGFloat)systemVersionFloat
{
    NSString *version_str = [FSSystem systemVersion];
    return [FSSystem versionFloatValue:version_str];
}

//应用版本转版本值float 如5.1.0＝>5.10
+(CGFloat)versionFloatValue:(NSString*)versionString
{
    NSArray *tmp = [versionString componentsSeparatedByString:@"."];
    if (tmp.count == 0) {
        return 0;
    }
    
    CGFloat version = [[tmp objectAtIndex:0] floatValue];
    
    NSUInteger i=1;
    CGFloat pow = 1;
    
    while (i < tmp.count)
    {
        NSString *s = [tmp objectAtIndex:i];
        pow *= powf(10, s.length);
        version += s.floatValue / pow;
        i++;
    }
    
    return version;
}
/*
 *判断版本号大小
 *@parm oldVer 当前版本号
 *@parm newVer 新版的版本号
 *@return BOOL 是否需要更新
 *规则5.9.4>5.9.3  5.10.0>5.9.9  6>5.9.9
 */
+ (BOOL)needUpdatewithNewVer:(NSString*)newVer oldVer:(NSString*)oldVer
{
    if (!newVer || !oldVer) {
        return NO;
    }
    if ([oldVer compare:newVer options:NSNumericSearch] == NSOrderedAscending) {
        //升序 new>old
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 设备
//设备ＭＡＣ地址
+ (NSString *) macAddress
{
    static NSMutableString *MAC_ADDRESS = nil;
    
    if (MAC_ADDRESS) {
        return MAC_ADDRESS;
    }
    
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%x:%x:%x:%x:%x:%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%x%x%x%x%x%x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    if (outstring)
    {
        MAC_ADDRESS = [NSMutableString stringWithCapacity:10];
        [MAC_ADDRESS setString:[outstring uppercaseString]];
    }
    
    return MAC_ADDRESS;
}

//设备id ios7之前为MAC地址，ios7之后为IDFA
+(NSString*)fmDeviceId
{
#warning 尝试用keychain解决 设备id不一致问题
    NSString *udid = [OpenUDID valueWithKeychain];
        
    if (!udid)
        udid = [[UIDevice currentDevice].identifierForVendor UUIDString];
//udid = @"00000000";
    return udid;
}

+ (NSString *)fmDeviceIDFA
{
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
    //    if ([self getOSVersion] > 6.0) {
    //        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //        return idfa;
    //    }
    //#endif
    return nil;
}

+ (NSString *)getDeviceVersion
{
    struct utsname systemInfo;
    uname(&systemInfo);
    //get the device model and the system version
    NSString *machine =[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return machine;
}

//设备操作系统版本
+ (CGFloat)getOSVersion
{
    NSString *value = [[UIDevice currentDevice]systemVersion];
    return [self versionFloatValue:value];
}

//是否iPad
+ (BOOL)isIpad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

//是否iPhone
+ (BOOL)isIphone
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

//是否越狱
+ (BOOL)isJailbroken {
    
    FILE *f = fopen("/bin/bash", "r");
    BOOL isJailbroken = NO;
    if (f != NULL)
        // Device is jailbroken
        isJailbroken = YES;
    else
        // Device isn't jailbroken
        isJailbroken = NO;
    
    fclose(f);
    
    return isJailbroken;
}

//设备型号，运营商
+ (NSString *) platformString{
    // Gets a string with the device model
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 2G (GSM)";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G (GSM)";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS (GSM)";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev.A 8G)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S (GSM+CDMA )";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM)";
    
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (Wi-Fi,32纳米)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM+WCDMA)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini 4G(EVDO+WCDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA2000)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 4G(EVDO+WCDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPadAir (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPadAir (LTE)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPadmini2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPadmini2 (LTE)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (DeviceType) getDeviceType
{
    if([UIScreen instancesRespondToSelector:@selector(currentMode)])
    {
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        if(CGSizeEqualToSize(CGSizeMake(640, 960),size)){
            return DeviceType_iPhone4s;
        }else if(CGSizeEqualToSize(CGSizeMake(640, 1136),size)){
            return DeviceType_iPhone5;
        }else if(CGSizeEqualToSize(CGSizeMake(750, 1334),size)){
            return DeviceType_iPhone6;
        }else if(CGSizeEqualToSize(CGSizeMake(1242, 2208),size)){
            return DeviceType_iPhone6plus;
        }
    }
    return DeviceType_iPhone4s;
}
#pragma mark- 网络状态
+ (NSString*)networkStatus
{
    if ([self connectedViaWiFi]) {
        return @"WIFI";
    }
    else if ([self connectedVia3G])
    {
        return @"3G";
    }
    return @"2G";
}

//是否ＷＩＦＩ
+ (BOOL)connectedViaWiFi {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi)
        return YES;
    else
        return NO;
}

//是否3Ｇ
+ (BOOL)connectedVia3G {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWWAN)
        return YES;
    else
        return NO;
}

//屏幕尺寸
+(CGSize)screenSize
{
    CGSize  size;
    CGRect  rect_screen = [[UIScreen mainScreen] bounds];
    CGSize  size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    size = CGSizeMake(size_screen.width*scale_screen, size_screen.height*scale_screen);
    return size;
}

@end
