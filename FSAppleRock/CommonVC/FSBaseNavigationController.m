 //
//  FSBaseNavigationController.m
//  FSAppleRock
//
//  Created by ZhangLan_PC on 16/7/11.
//  Copyright © 2016年 fangstar.net. All rights reserved.
//

#import "FSBaseNavigationController.h"

@interface FSBaseNavigationController ()

@end

@implementation FSBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    
    return self.topViewController;
//    NSArray *childViewControllers = self.navigationController.viewControllers;
//    NSUInteger childVCCount = childViewControllers.count;
//    if (!childVCCount)
//    {
//        return [super childViewControllerForStatusBarStyle];
//    }
//    
//    UIViewController *smLookHouseListByDate = [childViewControllers firstObject];
//    if (smLookHouseListByDate.class == NSClassFromString(@"SMLookHouseListByDateVC")) {
//        return self.viewControllers[1];
//    }
//    
//    return [super childViewControllerForStatusBarStyle];
//    UIViewController *smHelperDetailVC = nil;
//    for (UIViewController *vc in childViewControllers) {
//        if (vc.class == NSClassFromString(@"SMLookHouseHelperDetailVC")) {
//            smHelperDetailVC = vc;
//        }
//    }
//    
//    if (!smHelperDetailVC)
//    {
//        return [super childViewControllerForStatusBarStyle];
//    }
//    else
//    {
//        return smHelperDetailVC;
//    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
