//
//  WCStageSetting.m
//  VIP
//
//  Created by NJWC on 16/4/11.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCStageSetting.h"
#import "WCStageList.h"

@implementation WCStageSetting

MJCodingImplementation

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"stageList" : [WCStageList class]};
}

@end
