//
//  UIImageView+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/8/12.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "UIImageView+FSUtility.h"

@implementation UIImageView (FSUtility)

- (void)setCircleImageView
{
    [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
    self.layer.masksToBounds = YES;
    self.layer.contents = (id)[self.image CGImage];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1.0;
}

@end
