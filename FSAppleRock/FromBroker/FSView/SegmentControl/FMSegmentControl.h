//
//  FMSegmentControl.h
//  FMLibrary
//
//  Created by fangstar on 13-4-22.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMView.h"

@class FMSegmentControl;

@protocol FMSegmentControlDelegate <NSObject>

-(void)fmSegmentControl:(FMSegmentControl*)fmSegmentControl didSelectedAtTag:(NSUInteger)tag;

@end

@interface FMSegmentControl : FMView
{
    NSMutableArray *_buttons;
    IBOutlet UIImageView *slideIcon;
    IBOutlet UIButton *slideReferentialButton;
    CGFloat slideCenterDvalueX;
    CGFloat slideCenterDvalueY;
    
    
    id<FMSegmentControlDelegate> _delegate;
    BOOL _showsTouchWhenHighlighted;
    BOOL _repeatTouchEnabled;
    BOOL _slideAnimation;
    NSUInteger _selectedTag;
}
@property (nonatomic, assign) IBOutlet id<FMSegmentControlDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *buttons;
@property (nonatomic, retain) UIImageView *slideIcon;
@property (nonatomic) BOOL showsTouchWhenHighlighted;
@property (nonatomic) BOOL repeatTouchEnabled;
@property (nonatomic) BOOL slideAnimation;
@property (nonatomic) NSUInteger selectedTag;

@end
