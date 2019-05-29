//
//  MBProgressHUD+FSUtility.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/19.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "MBProgressHUD+FSUtility.h"
#import "NSString+FSUtility.h"
#import "UIColor+FSUtility.h"
#import "UIView+FSUtility.h"
#import "UILabel+FSUtility.h"

#define kDismissDelayTime        2.0
#define kScreenWidth             [UIScreen mainScreen].bounds.size.width

@implementation MBProgressHUD (FSUtility)

/**
 *  提示(2s后消失)
 *
 *  @param message 提示信息
 *  @param inView  显示view
 */
+ (void)showMessage:(NSString *)message inView:(UIView *)inView
{
    [self showMessage:message withIcon:nil inView:inView];
}

/**
 *  带icon的提示
 *
 *  @param message  提示信息
 *  @param withIcon icon
 *  @param inView
 */
+ (void)showMessage:(NSString *)message withIcon:(NSString *)withIcon inView:(UIView *)inView
{
    if (!inView)
    {
        inView = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    
    // 设置行间距
    [hud.label setLineSpacing:4 withString:message];
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", withIcon]]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:kDismissDelayTime];
}

+ (void)showError:(NSString *)error inView:(UIView *)inView
{
    [self showMessage:error withIcon:@"HUD_Error" inView:inView];
}

+ (void)showSuccess:(NSString *)success inView:(UIView *)inView
{
    [self showMessage:success withIcon:@"HUD_Success" inView:inView];
}

#pragma mark 加载中（需要手动关闭）

+ (MBProgressHUD *)showLodingMessage:(NSString *)message inView:(UIView *)inView
{
    if (!inView)
    {
        inView = [[UIApplication sharedApplication].windows lastObject];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    hud.label.text = message;
    
    [hud.label setLineSpacing:4 withString:message];
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    
    return hud;
}

#pragma mark - hideHUD
+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view];
}


@end
