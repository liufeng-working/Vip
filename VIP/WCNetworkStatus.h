//
//  WCNetworkStatus.h
//  VIP
//
//  Created by NJWC on 16/3/21.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

//利用私有API快速检测当前网络状况

typedef enum
{
    WCUnknown = -1,          //未知网络
    WCNoWifiOrCellular = 0,  //
    WC2G = 1,                //2G
    WC3G = 2,                //3G
    WC4G = 3,                //4G
    WCLTE = 4,
    WCWifi = 5               //WIFI
    
} WCNetworkStatusType;

@interface WCNetworkStatus : NSObject

+(WCNetworkStatusType) currentStatus;

+(BOOL)isAvailableNetwork;

@end
