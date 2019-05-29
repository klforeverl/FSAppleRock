//
//  FMUTestData.h
//  FMLibrary
//
//  Created by fangstar on 13-4-17.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUTestData : NSObject

+(NSString*)thumbImageUrl;
+(NSString*)lagetImageUrl;

+(NSString*)name;
+(NSString*)address;

+(NSString*)randomId:(NSUInteger)max;
+(NSString*)randomDateString;
+(NSString*)phoneNumber;
+(NSString*)huXing;
+(NSString*)content;
+(NSString*)houseFurnishingName;
+(NSString*)category;
@end
