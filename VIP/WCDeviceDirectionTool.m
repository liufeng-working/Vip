//
//  WCDeviceDirectionTool.m
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

/**
 *  管理屏幕方向
 */
#import "WCDeviceDirectionTool.h"

@implementation WCDeviceDirectionTool

+ (instancetype)shareDeviceDirection
{
    static WCDeviceDirectionTool *_device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _device = [[self alloc]init];
    });
    return _device;
}

@end
