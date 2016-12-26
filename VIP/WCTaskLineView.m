//
//  WCTaskLineView.m
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTaskLineView.h"
#import "WCRoadLineView.h"

@interface WCTaskLineView ()

@end

@implementation WCTaskLineView

+(instancetype)taskLineViewWithFrame:(CGRect)frame
{
    WCTaskLineView * taskLineView = [[[NSBundle mainBundle] loadNibNamed:@"WCTaskLineView" owner:nil options:nil] lastObject];
    taskLineView.frame = frame;
    return taskLineView;
}

-(void)setNameArr:(NSArray<NSString *> *)nameArr
{
    _nameArr = nameArr;
    
    self.roadLineView.width = 688;
    self.roadLineView.nameArr = nameArr;
    self.roadLineView.count = 7;
    self.roadLineView.roadLineViewType = WCRoadLineViewTypeSenvenName;
    [self.roadLineView settingRoadLine];
}

@end
