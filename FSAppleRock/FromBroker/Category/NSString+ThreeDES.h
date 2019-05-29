//
//  NSString+ThreeDES.h
//  FSLibrary
//
//  Created by XuLei on 15/8/20.
//  Copyright (c) 2015年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ThreeDES)
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key;
- (NSString*) sha1;
@end
