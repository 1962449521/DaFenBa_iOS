//
//  GalleryManager.m
//  DaFenBa
//
//  Created by 胡 帅 on 14-8-20.
//  Copyright (c) 2014年 胡 帅. All rights reserved.
//

#import "GalleryManager.h"

@implementation GalleryManager

+ (id)shareInstance
{
    static dispatch_once_t once;
    Class class = [self class];
    static GalleryManager* instance;
    dispatch_once(&once, ^{
        instance = [[class alloc]init];
    });
    if (instance) {
        if (!instance.dataSourceFujing) {
            instance.dataSourceFujing = [NSMutableArray arrayWithCapacity:0];
        }
        if (!instance.dataSourceGuanZhu) {
            instance.dataSourceGuanZhu = [NSMutableArray arrayWithCapacity:0];
        }
        if (!instance.dataSourceTuijian) {
            instance.dataSourceTuijian = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return instance;
}

- (NSMutableArray *)selectedDataSource
{
    switch (self.selectedIndex) {
        case 0:
            return self.dataSourceTuijian;
            break;
        case 1:
            return self.dataSourceGuanZhu;
            break;
        case 2:
            return self.dataSourceFujing;
            break;

        default:
            return nil;
            break;
    }
}

@end
