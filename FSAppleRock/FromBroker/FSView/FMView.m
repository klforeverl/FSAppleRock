//
//  FMView.m
//  FMLibrary
//
//  Created by fangstar on 13-3-21.
//  Copyright (c) 2013年 fangstar. All rights reserved.
//

#import "FMView.h"

NSString *const kFMViewException = @"kFMViewException";

@implementation FMView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 从xib文件中载入
 @param nibName xib文件名
 @return 
 */
+(id)viewWithNibName:(NSString *)nibName
{
    return [[self class] viewWithNibName:nibName atIndex:0];
}

+(id)viewWithNibName:(NSString *)nibName atIndex:(NSUInteger)index
{
    NSUInteger tmp = 0;
    
    NSArray* nib_objects = [[NSBundle mainBundle] loadNibNamed:nibName
                                                         owner:self
                                                       options:nil];
    if (nib_objects.count > 0)
    {
        for (int i=0; i<nib_objects.count; i++)
        {
            id obj = [nib_objects objectAtIndex:i];
            if ([obj isKindOfClass:[self class]])
            {
                if (tmp < index) {
                    tmp++;
                    continue ;
                }
                FMView *view_from_nib = [nib_objects objectAtIndex:i];
                return view_from_nib;
            }
        }
    }
    
    NSException* myException = [NSException
                                exceptionWithName:kFMViewException
                                reason:[NSString stringWithFormat:@"No matching view in nib %@", nibName]
                                userInfo:nil];
    @throw myException;
    
    return nil;
}
@end
