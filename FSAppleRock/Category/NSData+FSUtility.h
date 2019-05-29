//
//  NSData+FSUtility.h
//  FSAppleRock
//
//  Created by Xulei on 30/11/2016.
//  Copyright © 2016 fangstar.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (FSUtility)

/**
 Returns a lowercase NSString for sha1 hash.
 */
- (NSString *)sha1String;

/**
 Returns an NSData for sha1 hash.
 */
- (NSData *)sha1Data;
@end
