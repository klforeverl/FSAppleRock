//
//  FMSegmentControl.m
//  FMLibrary
//
//  Created by fangstar on 13-4-22.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMSegmentControl.h"

@implementation FMSegmentControl
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;
@synthesize slideIcon;
@synthesize showsTouchWhenHighlighted = _showsTouchWhenHighlighted;
@synthesize repeatTouchEnabled = _repeatTouchEnabled;
@synthesize slideAnimation = _slideAnimation;
@synthesize selectedTag = _selectedTag;

-(void)dealloc
{
    [slideIcon release];
    [_buttons release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)awakeFromNib
{
    _buttons = [[NSMutableArray alloc] init];
    NSArray *sviews = [self subviews];
    for (int i=0; i<sviews.count; i++)
    {
        NSObject *child = [sviews objectAtIndex:i];
        if ([child isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton*)child;
            [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_buttons addObject:btn];
            
            UIImage *dImg = [btn backgroundImageForState:UIControlStateNormal];
            if (dImg) {
                CGSize ds = dImg.size;
                [btn setBackgroundImage:[dImg stretchableImageWithLeftCapWidth:ds.width/2 topCapHeight:ds.height/2] forState:UIControlStateNormal];
            }
            UIImage *hImg = [btn backgroundImageForState:UIControlStateHighlighted];
            if (hImg) {
                CGSize hs = hImg.size;
                [btn setBackgroundImage:[hImg stretchableImageWithLeftCapWidth:hs.width/2 topCapHeight:hs.height/2] forState:UIControlStateHighlighted];
            }
            UIImage *sImg = [btn backgroundImageForState:UIControlStateSelected];
            if (sImg) {
                CGSize ss = sImg.size;
                [btn setBackgroundImage:[sImg stretchableImageWithLeftCapWidth:ss.width/2 topCapHeight:ss.height/2] forState:UIControlStateSelected];
            }
        }
    }
    
    if (slideReferentialButton && slideIcon) {
        CGPoint rCenter = slideReferentialButton.center;
        CGPoint iCenter = slideIcon.center;
        slideCenterDvalueX = iCenter.x - rCenter.x;
        slideCenterDvalueY = iCenter.y - rCenter.y;
    }
}

-(void)buttonAction:(id)sender
{
    UIButton *clicked_button = (UIButton *)sender;
    NSUInteger button_tag = clicked_button.tag;
    _selectedTag = button_tag;
    
    for (int i=0; i<_buttons.count; i++) {
        UIButton *btn = (UIButton *)[_buttons objectAtIndex:i];
        btn.selected = NO;
        btn.userInteractionEnabled = YES;
    }
    
    clicked_button.selected = YES;
    if (_repeatTouchEnabled)  clicked_button.userInteractionEnabled = YES;
    else clicked_button.userInteractionEnabled = NO;
    
    if (slideIcon && slideReferentialButton) {
        CGPoint rCenter = slideReferentialButton.center;
        CGPoint bCenter = clicked_button.center;
        CGFloat bCenterDvalueX = 0.0;
        CGFloat bCenterDvalueY = 0.0;
        if (slideCenterDvalueY == 0.0 && slideCenterDvalueX != 0.0) {
            bCenterDvalueX = -(bCenter.x - rCenter.x)*(slideCenterDvalueX/fabs(slideCenterDvalueX));
        }
        if (slideCenterDvalueX == 0.0 && slideCenterDvalueY != 0.0) {
            bCenterDvalueY = -(bCenter.y - rCenter.y)*(slideCenterDvalueY/fabs(slideCenterDvalueY));
        }

        CGPoint iCenter = CGPointMake(clicked_button.center.x + slideCenterDvalueX + bCenterDvalueX, clicked_button.center.y + slideCenterDvalueY + bCenterDvalueY);
        if (_slideAnimation) {
            [UIView animateWithDuration:0.2f animations:^{
                slideIcon.center = iCenter;
            }];
        }
        else slideIcon.center = iCenter;
    }
    
    if ([_delegate respondsToSelector:@selector(fmSegmentControl:didSelectedAtTag:)])
    {
        [_delegate fmSegmentControl:self didSelectedAtTag:_selectedTag];
    }
}

- (void)setSelectedTag:(NSUInteger)selectedTag
{
    _selectedTag = selectedTag;
    
    for (int i=0; i<_buttons.count; i++)
    {
        UIButton *sButton = (UIButton *)[_buttons objectAtIndex:i];
        if (sButton.tag == selectedTag)
        {
            [self buttonAction:sButton];
            return ;
        }
    }
}

@end
