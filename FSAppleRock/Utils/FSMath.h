//
//  FSMath.h
//  FMLibrary
//
//  Created by fangstar on 13-3-22.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

CG_INLINE CGRect
FSRectSetX(CGRect r, CGFloat x)
{
    CGRect rect;
    rect.origin.x = x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectSetY(CGRect r, CGFloat y)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectSetOrigin(CGRect r, CGPoint origin)
{
    CGRect rect;
    rect.origin.x = origin.x;
    rect.origin.y = origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectSetWidth(CGRect r, CGFloat width)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectSetHeight(CGRect r, CGFloat height)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = height;
    return rect;
}

CG_INLINE CGRect
FSRectSetSize(CGRect r, CGSize size)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = size.width;
    rect.size.height = size.height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetX(CGRect r, CGFloat x)
{
    CGRect rect;
    rect.origin.x = r.origin.x + x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetY(CGRect r, CGFloat y)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y + y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetOrigin(CGRect r, CGPoint offset)
{
    CGRect rect;
    rect.origin.x = r.origin.x + offset.x;
    rect.origin.y = r.origin.y + offset.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetWidth(CGRect r, CGFloat width)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width + width;
    rect.size.height = r.size.height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetHeight(CGRect r, CGFloat height)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width;
    rect.size.height = r.size.height + height;
    return rect;
}

CG_INLINE CGRect
FSRectOffsetSize(CGRect r, CGSize size)
{
    CGRect rect;
    rect.origin.x = r.origin.x;
    rect.origin.y = r.origin.y;
    rect.size.width = r.size.width + size.width;
    rect.size.height = r.size.height + size.height;
    return rect;
}

@interface FSMath : NSObject

/*
 判断某个点是否在矩形内
 */
+(BOOL)isPoint:(CGPoint)p inRect:(CGRect)rect;

/*
 判断两个矩形是否有交集
 */
+(BOOL)isRect:(CGRect)r1 intersectRect:(CGRect)r2;

/*
 计算文件大小，格式化显示
 */
+(NSString*)formattedTextForFileSize:(NSNumber*)fileSize;
@end