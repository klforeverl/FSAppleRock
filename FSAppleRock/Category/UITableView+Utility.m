//
//  UITableView+Utility.m
//  FangStarBroker
//
//  Created by zhanglan on 15/11/19.
//  Copyright © 2015年 fangstar. All rights reserved.
//

#import "UITableView+Utility.h"

@implementation UITableView (Utility)

// 隐藏表格中没有数据的行的分割线
-(void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}

@end
