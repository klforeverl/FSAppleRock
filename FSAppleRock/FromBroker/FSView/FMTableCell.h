//
//  FMTableCell.h
//  FMLibrary
//
//  Created by fangstar on 13-4-18.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMBean;
@class FMTableController;

@interface FMTableCell : UITableViewCell
{
}

@property (nonatomic, strong) FMBean *cellData;
@property (nonatomic, assign) id parent;

-(void)reloadCellData:(FMBean*)cellData;

@end
