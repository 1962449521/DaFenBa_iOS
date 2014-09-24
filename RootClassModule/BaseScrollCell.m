//
//  BaseScrollCell.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-8-31.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "BaseScrollCell.h"

@implementation BaseScrollCell
{
    BOOL lockCondition;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lockCondition = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)tap:(id)sender {
}
- (IBAction)longPress:(id)sender {
    if (lockCondition)
        return;
    lockCondition = YES;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提醒"
                                                       message:@"亲，真的忍心删掉我吗？"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"不删了",@"删除", nil];
    [alertView show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    lockCondition = NO;
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
           [self.delegete removeCellData:self];
        }
            break;
        default:
            break;
    }
}
- (void)assignValue:(id)cellView
{
    
}
@end
