//
//  WCCommonRouteView.m
//  VIP
//
//  Created by NJWC on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCCommonRouteView.h"

@implementation WCCommonRouteView

+(instancetype)commonRouteViewWithFrame:(CGRect)frame
{
    WCCommonRouteView * commonRouteView = [[[NSBundle mainBundle] loadNibNamed:@"WCCommonRouteView" owner:nil options:nil] lastObject];
    commonRouteView.frame = frame;
    return commonRouteView;
}

@end
