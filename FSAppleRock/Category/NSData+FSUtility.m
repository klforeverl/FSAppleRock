//
//  NSData+FSUtility.m
//  FSAppleRock
//
//  Created by Xulei on 30/11/2016.
//  Copyright © 2016 fangstar.net. All rights reserved.
//

#import "NSData+FSUtility.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation NSData (FSUtility)


- (NSString *)sha1String
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    NSMutableString *hash = [NSMutableString
                             stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}

- (NSData *)sha1Data
{
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(self.bytes, (CC_LONG)self.length, result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

@end
