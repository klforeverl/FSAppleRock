//
//  FMAlertView.m
//  FMLibrary
//
//  Created by fangstar on 13-3-21.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define FMALERTVIEW_ANIMATION_DURATION 0.5f

#define FMALERTVIEW_MAX_WIDTH 256.0f
#define FMALERTVIEW_MAX_HEIGHT 144.0f
#define FMALERTVIEW_EDGE_INSET 10.0f

@implementation FMAlertView
@synthesize delegate = _delegate;
@synthesize style = _style;
@synthesize animationType = _animationType;
@synthesize alignment = _alignment;
@synthesize autoDismissSeconds = _autoDismissSeconds;
@synthesize duration = _duration;
@synthesize viewInsets = _viewInsets;
@synthesize contentOffset = _contentOffset;
@synthesize bodyTextLabel = _bodyTextLabel;
@synthesize bodyTextView = _bodyTextView;
@synthesize indicator = _indicator;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize closeButton = _closeButton;

-(void)dealloc
{
    [self.layer removeAllAnimations];
    [_dimWindow release];
    _dimWindow = nil;
    [_bodyTextLabel release];
    [_bodyTextView release];
    [_indicator release];
    [_backgroundImageView release];
    [_closeButton release];
    [super dealloc];
}

#pragma mark - 初始化

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    _maxHeight = self.bounds.size.height > FMALERTVIEW_MAX_HEIGHT ? self.bounds.size.height:FMALERTVIEW_MAX_HEIGHT - FMALERTVIEW_EDGE_INSET * 2;
    _maxWidth = self.bounds.size.width > FMALERTVIEW_MAX_WIDTH ? self.bounds.size.width:FMALERTVIEW_MAX_WIDTH - FMALERTVIEW_EDGE_INSET * 2;
    
    [_closeButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
}

+(id)defaultAlertView
{
    FMAlertView *alert = [FMAlertView viewWithNibName:@"FMViewResources"];
    return alert;
}

#pragma mark - 显示调用
/*
 只有全屏模式可用
 */
-(void)show
{
    [self layoutMe];
    
    if (!_dimWindow) {
        UIWindow *kwindow = [[[UIApplication sharedApplication] delegate] window];
        CGRect r = [kwindow.rootViewController.view bounds];
        _dimWindow = [[UIWindow alloc] initWithFrame:r];
        _dimWindow.backgroundColor = [UIColor clearColor];
        [_dimWindow setWindowLevel:UIWindowLevelStatusBar];
        UINavigationController *vc = [[UINavigationController alloc] init];
        vc.navigationBarHidden = YES;
        vc.view.frame = _dimWindow.bounds;
        vc.view.backgroundColor = [UIColor clearColor];
        [_dimWindow setRootViewController:vc];
        [vc release];
    }
    
    [_dimWindow.rootViewController.view addSubview:self];
    
    [self alignMeInRect:_dimWindow.bounds];
    
    [_dimWindow makeKeyAndVisible];
    [self startAnimation];
}

/*
 附着模式
 */
-(void)showInView:(UIView*)parentView
{
    [self layoutMe];
    [self alignMeInRect:parentView.bounds];
    [parentView addSubview:self];
    
    [self startAnimation];
}

#pragma mark - 内部方法
/*
 计算对齐
 */
-(void)alignMeInRect:(CGRect)rect
{
    CGRect frame = self.frame;
    switch (_alignment)
    {
        case FMAlertViewAlignmentCenter:
            frame.origin.x = (rect.size.width - frame.size.width ) / 2;
            frame.origin.y = (rect.size.height - frame.size.height) / 2;
            break;
        case FMAlertViewAlignmentLeft:
            frame.origin.x = 0;
            frame.origin.y = (rect.size.height - frame.size.height) / 2;
            break;
        case FMAlertViewAlignmentRight:
            frame.origin.x = rect.size.width - frame.size.width;
            frame.origin.y = (rect.size.height - frame.size.height) / 2;
            break;
        case FMAlertViewAlignmentTop:
            frame.origin.x = (rect.size.width - frame.size.width ) / 2;
            frame.origin.y = 0;
            break;
        case FMAlertViewAlignmentBottom:
            frame.origin.x = (rect.size.width - frame.size.width ) / 2;
            frame.origin.y = rect.size.height - frame.size.height;
            break;
        case FMAlertViewAlignmentTopLeft:
            frame.origin.x = 0;
            frame.origin.y = 0;
            break;
        case FMAlertViewAlignmentTopRight:
            frame.origin.x = rect.size.width - frame.size.width;
            frame.origin.y = 0;
            break;
        case FMAlertViewAlignmentBottomLeft:
            frame.origin.x = 0;
            frame.origin.y = rect.size.height - frame.size.height;
            break;
        case FMAlertViewAlignmentBottomRight:
            frame.origin.x = rect.size.width - frame.size.width;
            frame.origin.y = rect.size.height - frame.size.height;
            break;
        default:
            break;
    }
    
    frame.origin.x += _viewInsets.left - _viewInsets.right;
    frame.origin.y += _viewInsets.top - _viewInsets.bottom;
    
    self.frame = frame;
}

-(void)layoutMe
{
    CGFloat total_width = 0;
    CGFloat total_height = 0;
    
    if (_indicator)
    {
        CGRect r = _indicator.frame;
        r.origin.x = FMALERTVIEW_EDGE_INSET;
        r.origin.y = FMALERTVIEW_EDGE_INSET;
        _indicator.frame = r;
        
        CGRect tr = _bodyTextLabel.frame;
        tr.origin.x = r.origin.x + r.size.width + FMALERTVIEW_EDGE_INSET/2;
        tr.origin.y = FMALERTVIEW_EDGE_INSET;
        _bodyTextLabel.frame = tr;
    }
    else
    {
        CGRect tr = _bodyTextLabel.frame;
        tr.origin.x = FMALERTVIEW_EDGE_INSET;
        tr.origin.y = FMALERTVIEW_EDGE_INSET;
        _bodyTextLabel.frame = tr;
    }
    
    CGFloat max_text_width = _maxWidth;
    CGFloat nontext_width = 0;
    
    if (_closeButton)
    {
        nontext_width += _closeButton.frame.size.width + FMALERTVIEW_EDGE_INSET/2;
        max_text_width -= _closeButton.frame.size.width + FMALERTVIEW_EDGE_INSET/2;
        
        if (_closeButton.frame.size.height > total_height)
        {
            total_height = _closeButton.frame.size.height;
        }
    }
    
    if (_indicator)
    {
        nontext_width += _indicator.frame.size.width + FMALERTVIEW_EDGE_INSET/2;
        max_text_width -= _indicator.frame.size.width + FMALERTVIEW_EDGE_INSET/2;
        
        if (_indicator.frame.size.height > total_height)
        {
            total_height = _indicator.frame.size.height;
        }
    }
    
    //正文
    if (_bodyTextLabel.text.length > 0)
    {
        _bodyTextLabel.hidden = NO;
        _bodyTextView.hidden = YES;
        
        CGSize bt_size = [_bodyTextLabel.text sizeWithFont:_bodyTextLabel.font forWidth:HUGE_VALF lineBreakMode:_bodyTextLabel.lineBreakMode];
        
        if (_bodyTextLabel.frame.origin.x + bt_size.width > max_text_width)
        {
            CGRect r = _bodyTextLabel.frame;
            r.size.width = max_text_width;
            _bodyTextLabel.frame = r;
            
            total_width = _maxWidth;
        }
        else
        {
            CGRect r = _bodyTextLabel.frame;
            r.size.width = bt_size.width;
            _bodyTextLabel.frame = r;
            total_width = nontext_width + bt_size.width;
        }
        
        
        
        _bodyTextLabel.numberOfLines = 0;
        [_bodyTextLabel sizeToFit];
        
        if (_bodyTextLabel.frame.origin.y + _bodyTextLabel.frame.size.height  >
            FMALERTVIEW_MAX_HEIGHT)
        {
            CGRect r = _bodyTextLabel.frame;
            r.size.height = FMALERTVIEW_MAX_HEIGHT - _bodyTextLabel.frame.origin.y ;
            _bodyTextLabel.frame = r;
            
            //用textView替换Label
            if (_bodyTextView)
            {
                _bodyTextView.frame = r;
                _bodyTextView.text = _bodyTextLabel.text;
                _bodyTextLabel.hidden = YES;
                _bodyTextView.hidden = NO;
                _bodyTextView.editable = NO;
            }
            
            total_height = FMALERTVIEW_MAX_HEIGHT;
        }
        else if (_bodyTextLabel.frame.origin.y + _bodyTextLabel.frame.size.height > total_height)
        {
            total_height = _bodyTextLabel.frame.origin.y + _bodyTextLabel.frame.size.height;
        }
        else
        {
            
        }
    }
    else
    {
        total_width += nontext_width - FMALERTVIEW_EDGE_INSET/2;
        total_height += FMALERTVIEW_EDGE_INSET;
    }
    
    CGRect r = self.frame;
    r.size = CGSizeMake(total_width + FMALERTVIEW_EDGE_INSET*2,
                        total_height + FMALERTVIEW_EDGE_INSET);
    self.frame = r;
    
    if (_closeButton)
    {
        CGRect r = _closeButton.frame;
        r.origin.x = _bodyTextLabel.frame.origin.x + _bodyTextLabel.frame.size.width + FMALERTVIEW_EDGE_INSET/2;
        _closeButton.frame = r;
    }
}

-(void)centerSubviews
{
    
    CGPoint topleft = CGPointMake(self.frame.size.width, self.frame.size.height);
    
    for (UIView *sub in self.subviews)
    {
        if (sub == _backgroundImageView ||
            sub == _bodyTextView ||
            [sub isKindOfClass:[UIButton class]]) {
            continue ;
        }
        
        if (sub.frame.origin.x < topleft.x) {
            topleft.x = sub.frame.origin.x;
        }
        
        if (sub && sub.frame.origin.y < topleft.y) {
            topleft.y = sub.frame.origin.y;
        }
    }
    
    UIOffset offset = UIOffsetMake(FMALERTVIEW_EDGE_INSET-topleft.x, FMALERTVIEW_EDGE_INSET-topleft.y);
    for (UIView *sub in self.subviews)
    {
        if (sub == _backgroundImageView ||
            [sub isKindOfClass:[UIButton class]]) {
            continue ;
        }
        
        CGRect r = sub.frame;
        r.origin.x += offset.horizontal;
        r.origin.y += offset.vertical;
        sub.frame = r;
    }
}

-(void)buttonClickAction:(id)sender
{
    UIButton *btn = sender;
    
    if([_delegate respondsToSelector:@selector(fmAlertView:willDismissWithButtonTag:)])
    {
        [_delegate fmAlertView:self willDismissWithButtonTag:btn.tag];
    }
    
    if (btn == _closeButton )
    {
        if ([_delegate respondsToSelector:@selector(fmAlertViewCanceled:)])
        {
            [_delegate fmAlertViewCanceled:self];
        }
    }
    
    [self dismiss];
}

#pragma mark - 动画Delegate

- (void)animationDidStart:(CAAnimation *)anim
{

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_dismissing)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        if([_delegate respondsToSelector:@selector(fmAlertView:didDismissWithButtonTag:)])
        {
            [_delegate fmAlertView:self didDismissWithButtonTag:_closeButton.tag];
        }
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
        [_dimWindow setHidden:YES];
        [_dimWindow release];
        _dimWindow = nil;
    }
    else
    {
        if (_autoDismissSeconds > 0) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:_autoDismissSeconds];
        }
    }
}

#pragma mark - 动画调用

-(void)startAnimation
{
    CAAnimation *animation = [self animationForType:_animationType isDimiss:NO];
    if (animation)
    {
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"showAnimation"];
    }
    else
    {
        if (_autoDismissSeconds > 0) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:_autoDismissSeconds];
        }
    }
}

-(void)dismiss
{
    CAAnimation *animation = [self animationForType:_animationType isDimiss:YES];
    if (animation)
    {
        animation.delegate = self;
        [self.layer addAnimation:animation forKey:@"dismissAnimation"];
    }
    else
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        if([_delegate respondsToSelector:@selector(fmAlertView:didDismissWithButtonTag:)])
        {
            [_delegate fmAlertView:self didDismissWithButtonTag:_closeButton.tag];
        }
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
        [_dimWindow setHidden:YES];
        [_dimWindow release];
        _dimWindow = nil;
    }
}

-(CAAnimation*)animationForType:(FMAlertViewAnimationType)type isDimiss:(BOOL)isDismiss
{
    _dismissing = isDismiss;
    
    CGFloat duration = self.duration;
    if (duration == 0) {
        duration = FMALERTVIEW_ANIMATION_DURATION;
    }
    
    if (type == FMAlertViewAnimationNone)
    {
        return nil;
    }
    else if (type == FMAlertViewAnimationFade)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        if (isDismiss)
        {
            animation.fromValue = [NSNumber numberWithFloat:1.0f];
            animation.toValue = [NSNumber numberWithFloat:0.0f];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        }
        else
        {
            animation.fromValue = [NSNumber numberWithFloat:0.0f];
            animation.toValue = [NSNumber numberWithFloat:1.0f];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        }
        return animation;
    }
    else if (type == FMAlertViewAnimationBounce)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:10];
        if (isDismiss)
        {
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            animation.duration = duration;
        }
        else
        {
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            animation.duration = duration;
        }
        
        animation.values = values;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        return animation;
    }
    else if (type == FMAlertViewAnimationFromLeft ||
             type == FMAlertViewAnimationFromRight ||
             type == FMAlertViewAnimationFromTop ||
             type == FMAlertViewAnimationFromBottom ||
             type == FMAlertViewAnimationFadeFromLeft ||
             type == FMAlertViewAnimationFadeFromRight ||
             type == FMAlertViewAnimationFadeFromTop ||
             type == FMAlertViewAnimationFadeFromBottom)
    {
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        NSMutableArray *animates = [NSMutableArray arrayWithCapacity:2];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;

        CGRect bounds = self.bounds;
        CGRect start = bounds;
        CGRect end = bounds;
        
        //坐标系是反的，
        if (isDismiss)
        {
            if (type == FMAlertViewAnimationFromLeft ||
                type == FMAlertViewAnimationFadeFromLeft)
            {
                end.origin.x = bounds.size.width;
            }
            else if (type == FMAlertViewAnimationFromRight ||
                     type == FMAlertViewAnimationFadeFromRight)
            {
                end.origin.x = -bounds.size.width;
            }
            else if (type == FMAlertViewAnimationFromTop ||
                     type == FMAlertViewAnimationFadeFromTop)
            {
                end.origin.y = bounds.size.height;
            }
            else if (type == FMAlertViewAnimationFromBottom ||
                     type == FMAlertViewAnimationFadeFromBottom)
            {
                end.origin.y = -bounds.size.height;
            }
        }
        else
        {
            if (type == FMAlertViewAnimationFromLeft ||
                type == FMAlertViewAnimationFadeFromLeft)
            {
                start.origin.x = bounds.size.width;
            }
            else if (type == FMAlertViewAnimationFromRight ||
                     type == FMAlertViewAnimationFadeFromRight)
            {
                start.origin.x = -bounds.size.width;
            }
            else if (type == FMAlertViewAnimationFromTop ||
                     type == FMAlertViewAnimationFadeFromTop)
            {
                start.origin.y = bounds.size.height;
            }
            else if (type == FMAlertViewAnimationFromBottom ||
                     type == FMAlertViewAnimationFadeFromBottom)
            {
                start.origin.y = -bounds.size.height;
            }
        }
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        animation.fromValue = [NSValue valueWithCGRect:start];
        animation.toValue = [NSValue valueWithCGRect:end];
        [animates addObject:animation];
        
        //带渐变
        if (type == FMAlertViewAnimationFadeFromLeft ||
            type == FMAlertViewAnimationFadeFromRight ||
            type == FMAlertViewAnimationFadeFromTop ||
            type == FMAlertViewAnimationFadeFromBottom)
        {
            CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeAnimation.duration = duration;
            fadeAnimation.removedOnCompletion = NO;
            fadeAnimation.fillMode = kCAFillModeForwards;
            
            if (isDismiss)
            {
                fadeAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
                fadeAnimation.toValue = [NSNumber numberWithFloat:0.0f];
                fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            }
            else
            {
                fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
                fadeAnimation.toValue = [NSNumber numberWithFloat:1.0f];
                fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            }
            
            [animates addObject:fadeAnimation];
        }
        
        animationGroup.delegate = self;
        animationGroup.duration = duration;
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.animations = animates;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        return animationGroup;
    }
    
    return nil;
}
@end
