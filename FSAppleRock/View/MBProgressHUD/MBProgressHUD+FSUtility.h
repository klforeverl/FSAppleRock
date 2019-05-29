
/****************************************************
 *Copyright (c) 2016 fangstar. All rights reserved.
 *FileName:     MBProgressHUD+FSUtility.h
 *Author:       zhanglan
 *Date:         16/7/19.
 *Description:  加载视图封装：当MBProgressHUD更新的时候，直接替换。
 *Others:
 *History:
 ****************************************************/

#import "MBProgressHUD.h"

@interface MBProgressHUD (FSUtility)

#pragma mark - 提示信息
/**
 *  根据message提示
 *
 *  @param message message
 *  @param inView  显示在view
 */
+ (void)showMessage:(NSString *)message inView:(UIView *)inView;


/**
 *  带icon的提示
 *
 *  @param message  提示信息
 *  @param withIcon icon
 *  @param inView
 */
+ (void)showMessage:(NSString *)message withIcon:(NSString *)withIcon inView:(UIView *)inView;

/**
 *  错误提示(带提示icon)
 *
 *  @param error  错误信息
 *  @param inView
 */
+ (void)showError:(NSString *)error inView:(UIView *)inView;
/**
 *  成功提示(带提示icon)
 *
 *  @param success 成功提示
 *  @param inView  
 */
+ (void)showSuccess:(NSString *)success inView:(UIView *)inView;

#pragma mark - 加载中提示
/**
 *  加载中（需要手动关闭）
 *
 *  @param message 提示
 *  @param view
 *
 *  @return 
 */
+ (MBProgressHUD *)showLodingMessage:(NSString *)message inView:(UIView *)inView;

#pragma mark - HideHUD
/**
 *  隐藏view的HUD
 *
 *  @param view
 */
+ (void)hideHUDForView:(UIView *)view;

/**
 *  隐藏 HUD
 */
+ (void)hideHUD;


@end
