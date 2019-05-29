//
//  FMUICreator.h
//  FMLibrary
//
//  Created by fangstar on 13-9-26.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMSegmentControl.h"

@interface FMButtonItemAttribute : NSObject
{
    NSString *_title;
    UIColor *_itemDefaultColor;
    UIColor *_itemHightLightColor;
    NSString *_defaultIcon;
    NSString *_highLightIcon;
    NSString *_defaultBgImage;
    NSString *_highLightBgImage;
    NSUInteger _tag;
    UIFont *_font;
    CGFloat _itemMaxWidth;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) UIColor *itemDefaultColor;
@property (nonatomic, retain) UIColor *itemHightLightColor;
@property (nonatomic, copy) NSString *defaultIcon;
@property (nonatomic, copy) NSString *highLightIcon;
@property (nonatomic, copy) NSString *defaultBgImage;
@property (nonatomic, copy) NSString *highLightBgImage;
@property (nonatomic) NSUInteger tag;
@property (nonatomic ,retain) UIFont *font;
@property (nonatomic) CGFloat itemMaxWidth;

@end

@interface FMUICreator : NSObject

+(FMSegmentControl*)createMainTabSegment:(NSString *)nibname;
+(UIButton *)createButton:(FMButtonItemAttribute *)attr target:(id)target Selector:(SEL)sel;
+(UIBarButtonItem *)createBarButtonItem:(FMButtonItemAttribute *)attr target:(id)target selector:(SEL)sel;

@end
