//
//  WCNetworkStatus.m
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCNetworkStatus.h"

@implementation WCNetworkStatus

+(WCNetworkStatusType) currentStatus
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"]    subviews];
    NSNumber *dataNetworkItemView = nil;
    //UIStatusBarDataNetworkItemView
    NSString *str = [NSString stringWithFormat:@"%@StatusBar%@Network%@View", @"UI",@"Data",@"Item"];
    Class cls = [NSClassFromString(str) class];
    
    for (id subview in subviews)
    {
        if([subview isKindOfClass:cls])
        {
            dataNetworkItemView = subview;
            break;
        }
    }
    if(dataNetworkItemView)
        return [[dataNetworkItemView valueForKey:@"dataNetworkType"] intValue];
    else
        return WCUnknown;
}

+(BOOL)isAvailableNetwork
{
    WCNetworkStatusType type = [self currentStatus];
    if (type != WCUnknown) {
        return YES;
    }
    return NO;
}

@end
