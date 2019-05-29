//
//  FMAlertView.h
//  FMLibrary
//
//  Created by fangstar on 13-3-21.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMView.h"

typedef NS_ENUM(NSInteger, FMAlertViewStyle) {
    FMAlertViewStyleFullscreen = 0, //默认全屏模式
    FMAlertViewStyleAttachToView,   //附着View模式，
};

typedef NS_ENUM(NSInteger, FMAlertViewAnimationType) {
    FMAlertViewAnimationNone = 0,       //无动画
    FMAlertViewAnimationFade,           //渐隐动画
    FMAlertViewAnimationBounce,         //弹出
    FMAlertViewAnimationFromTop,        //从上而下
    FMAlertViewAnimationFromBottom,     //从下而上
    FMAlertViewAnimationFromLeft,       //从左到右
    FMAlertViewAnimationFromRight,      //从右到左
    FMAlertViewAnimationFadeFromTop,    //从上而下渐出
    FMAlertViewAnimationFadeFromBottom, //从下而上渐出
    FMAlertViewAnimationFadeFromLeft,   //从左到右渐出
    FMAlertViewAnimationFadeFromRight   //从右到左渐出
};

typedef NS_ENUM(NSInteger, FMAlertViewAlignment) {
    FMAlertViewAlignmentCenter,         //默认整体居中
    FMAlertViewAlignmentLeft,           //左对齐居中
    FMAlertViewAlignmentRight,          //右对齐居中
    FMAlertViewAlignmentTop,            //置顶居中
    FMAlertViewAlignmentBottom,         //置底居中
    FMAlertViewAlignmentTopLeft,        //左上角
    FMAlertViewAlignmentTopRight,       //右上角
    FMAlertViewAlignmentBottomLeft,     //左下角
    FMAlertViewAlignmentBottomRight     //右下角
    
};

@protocol FMAlertViewDelegate;

@interface FMAlertView : FMView
{
    @public
    id <FMAlertViewDelegate> _delegate;
    
    //样式
    FMAlertViewStyle _style;
    FMAlertViewAnimationType _animationType;
    FMAlertViewAlignment _alignment;
    
    //可选参数
    CGFloat _autoDismissSeconds;
    CGFloat _duration;
    UIEdgeInsets _viewInsets;
    UIOffset _contentOffset;
    
    //contents
    UILabel   *_bodyTextLabel;
    UITextView   *_bodyTextView;
    
    UIActivityIndicatorView *_indicator;
    UIImageView *_backgroundImageView;
    
    UIButton *_closeButton;
    
    //内部数据
    UIWindow *_dimWindow;
    
    BOOL _dismissing;
    CGFloat _maxWidth;
    CGFloat _maxHeight;
}

@property(nonatomic,assign) id delegate;

/*
 全屏和附着View 两种模式
 */
@property(nonatomic,assign) FMAlertViewStyle style;

/*
 动画类型
 */
@property(nonatomic,assign) FMAlertViewAnimationType animationType;

/*
 对齐方式
 */
@property(nonatomic,assign) FMAlertViewAlignment alignment;

// 自动消失时间，默认0则不自动消失
@property(nonatomic) CGFloat autoDismissSeconds;

// 动画展现时间，不设置则使用默认值
@property(nonatomic) CGFloat duration;

// 用于设置偏移值（相对于外层容器）
@property(nonatomic) UIEdgeInsets viewInsets;

// 设置内容偏移值（在自动布局基础上做动态偏移）
@property(nonatomic) UIOffset contentOffset;

@property(nonatomic,retain) IBOutlet UILabel    *bodyTextLabel;
@property(nonatomic,retain) IBOutlet UITextView   *bodyTextView;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;
@property(nonatomic,retain) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic,retain) IBOutlet UIButton *closeButton;
+(id)defaultAlertView;

-(void)show;
-(void)dismiss;
-(void)showInView:(UIView*)parentView;

-(void)alignMeInRect:(CGRect)rect;
-(void)startAnimation;
@end


@protocol FMAlertViewDelegate <NSObject>
@optional

-(void)fmAlertView:(FMAlertView*)fmAlertView willDismissWithButtonTag:(NSInteger)buttonTag;
-(void)fmAlertView:(FMAlertView*)fmAlertView didDismissWithButtonTag:(NSInteger)buttonTag;

-(void)fmAlertViewCanceled:(FMAlertView*)fmAlertView;
@end