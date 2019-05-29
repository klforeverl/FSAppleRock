//
//  FMUICreator.m
//  FMLibrary
//
//  Created by fangstar on 13-9-26.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMUICreator.h"

@implementation FMButtonItemAttribute
@synthesize title = _title;
@synthesize defaultIcon = _defaultIcon;
@synthesize highLightIcon = _highLightIcon;
@synthesize defaultBgImage = _defaultBgImage;
@synthesize highLightBgImage = _highLightBgImage;
@synthesize tag = _tag;
@synthesize font = _font;
@synthesize itemMaxWidth = _itemMaxWidth;

- (void)dealloc
{
    [_title release];
    [_defaultIcon release];
    [_highLightIcon release];
    [_defaultBgImage release];
    [_highLightBgImage release];
    [_font release];
    
    [super dealloc];
}

-(id)init
{
    if (self == [super init]) {
        self.font = [UIFont systemFontOfSize:18.0f];
        self.itemMaxWidth = 90;
    }
    return self;
}

@end

@implementation FMUICreator

+(FMSegmentControl*)createMainTabSegment:(NSString *)nibname
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibname
                                                      owner:self
                                                    options:nil];
    if (nibViews.count > 0) {
        return (FMSegmentControl*)[nibViews objectAtIndex:0];
    }
    else {
        NSLog(@"DTUICreator::createRichSegment, error loading MainTabView...");
    }
    
    return nil;
}

+(UIButton *)createButton:(FMButtonItemAttribute *)attr target:(id)target Selector:(SEL)sel
{
    CGSize btnSize = CGSizeMake(40, 40);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = attr.tag;
    
    if (attr.title) {
        //标题
        [btn setTitle:attr.title forState:UIControlStateNormal];
        btn.titleLabel.font = attr.font;
        if (attr.itemDefaultColor) {
            [btn setTitleColor:attr.itemDefaultColor forState:UIControlStateNormal];
        }
        else [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (attr.itemHightLightColor) {
            [btn setTitleColor:attr.itemHightLightColor forState:UIControlStateHighlighted];
        }
        else [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    }
    if ([UIImage imageNamed:attr.defaultIcon]) {
        //icon
        [btn setImage:[UIImage imageNamed:attr.defaultIcon] forState:UIControlStateNormal];
        if ([UIImage imageNamed:attr.highLightIcon]) {
            [btn setImage:[UIImage imageNamed:attr.highLightIcon] forState:UIControlStateHighlighted];
        }
    }
    
    [btn sizeToFit];
    CGSize bs = btn.frame.size;
    if (bs.width > btnSize.width) {
        btnSize.width = bs.width+4;
    }
//    if (bs.height > btnSize.height) {
//        btnSize.height = bs.height;
//    }
    
    //背景图
    UIImage *dImg = [UIImage imageNamed:attr.defaultBgImage];
    if (dImg) {
        [btn setBackgroundImage:[dImg stretchableImageWithLeftCapWidth:dImg.size.width/2 topCapHeight:dImg.size.height/2] forState:UIControlStateNormal];
        btnSize.height = dImg.size.height;
    }
    UIImage *sImg = [UIImage imageNamed:attr.highLightBgImage];
    if (sImg) {
        [btn setBackgroundImage:[sImg stretchableImageWithLeftCapWidth:sImg.size.width/2 topCapHeight:sImg.size.height/2] forState:UIControlStateSelected];
        btnSize.height = sImg.size.height;
    }
    btn.frame = CGRectMake(0, 0, btnSize.width, btnSize.height);
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+(UIBarButtonItem *)createBarButtonItem:(FMButtonItemAttribute *)attr target:(id)target selector:(SEL)sel;
{
    UIButton *btn = [self createButton:attr target:target Selector:sel];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return [item autorelease];
}

@end
