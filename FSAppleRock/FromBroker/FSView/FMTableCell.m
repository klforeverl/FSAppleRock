//
//  FMTableCell.m
//  FMLibrary
//
//  Created by fangstar on 13-4-18.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMTableCell.h"
#import "FMBean.h"

@implementation FMTableCell
@synthesize cellData = _cellData;
@synthesize parent = _parent;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reloadCellData:(FMBean*)cellData
{
    self.cellData = cellData;
}

@end
