//
//  WCFormHeaderView.m
//  VIP
//
//  Created by NJWC on 16/3/29.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCFormHeaderView.h"

@implementation WCFormHeaderView

+ (instancetype)formHeaderView
{
    WCFormHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"WCFormHeaderView" owner:nil options:nil] lastObject];
    return headerView;
}

@end
