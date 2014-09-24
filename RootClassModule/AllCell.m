//
//  AllCell.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-7-30.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "AllCell.h"

@implementation AllCell

/**
 *	@brief	注册NIB文件
 *
 *  @param  cellIdentifiew nib文件名
 *	@param 	tableView 	cell所在的tableView
 *
 *	@return	由nib文件生成cell对象
 */
/**
 *	@brief	注册NIB文件
 *
 *  @param  cellIdentifiew nib文件名
 *	@param 	tableView 	cell所在的tableView
 *
 *	@return	由nib文件生成cell对象
 */
+ (id)cellRegisterNib:(NSString *)cellIdentifier tableView:(UITableView *)tableView

{
    Class clazz = [self class];
    UINib *nib = [UINib nibWithNibName:cellIdentifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    id cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier
                                                     owner:self options:nil];
        
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[clazz class]]) {
                cell = oneObject;
                break;
            }
        }
    }
    return cell;
}
- (void)setDataSource:(NSDictionary *)dataSource
{
    
}
@end
