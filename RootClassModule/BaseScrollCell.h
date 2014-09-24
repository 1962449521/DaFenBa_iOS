//
//  BaseScrollCell.h
//  DaFenBa
//
//  Created by 胡 帅 on 14-8-31.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//
@class BaseScrollCell;
@protocol BaseScrollCellDelegate <NSObject>
@optional
- (void) removeCellData:(BaseScrollCell *)cellView;

@end

#import <UIKit/UIKit.h>


@interface BaseScrollCell : UIView<UIAlertViewDelegate>

@property (nonatomic, strong) id cellData;
@property (nonatomic, weak) id<BaseScrollCellDelegate> delegete;

- (void)assignValue:(id)cellData;
- (IBAction)tap:(id)sender;
- (IBAction)longPress:(id)sender;

@end
