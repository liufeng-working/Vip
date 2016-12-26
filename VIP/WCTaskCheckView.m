//
//  WCTaskCheckView.m
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTaskCheckView.h"
#import "WCTaskLineView.h"
#import "WCRoadLineView.h"

@implementation WCTaskCheckView

-(instancetype)initWithFrame:(CGRect)frame withType:(WCTaskCheckViewType)taskCheckViewType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.taskCheckViewType = taskCheckViewType;
    }
    return self;
}



-(void)settingViewStyle
{
    __weak typeof(self) weakSelf   =self ;
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (weakSelf.taskCheckViewType) {
            case WCTaskCheckViewTypePerforming:
                [weakSelf performingView];
                break;
            case WCTaskCheckViewTypePerformWait:
                [weakSelf performWaitView];
                break;
            case WCTaskCheckViewTypepeperformed:
                [weakSelf performedView];
                break;
            default:
                break;
        }
    });
   
}

-(void)performingView
{
    for (NSInteger i = 0; i < 3; i ++)
    {
        WCTaskLineView * taskLineView = [WCTaskLineView taskLineViewWithFrame:CGRectMake(tLineViewAndTabDis, tLineViewAndNavDis + (tLineDistance + 135) * i, 819.5 + 95, 135)];
        taskLineView.nameArr = @[
                                 @"清水亭西/",
                                 @"吉印大道/",
                                 @"金鑫东路/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"苏源大道/",
                                 @"秣周东路/",
                                 @"清水西苑/"
                                 ];
        [self addSubview:taskLineView];
    }
}
-(void)performWaitView
{
    for (NSInteger i = 0; i < 4; i ++)
    {
        WCTaskLineView * taskLineView = [WCTaskLineView taskLineViewWithFrame:CGRectMake(tLineViewAndTabDis, tLineViewAndNavDis + (tLineDistance + 135) * i, 819.5 + 95, 135)];
        taskLineView.nameArr = @[
                                 @"清水亭西/",
                                 @"吉印大道/",
                                 @"金鑫东路/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"清水亭西/",
                                 @"苏源大道/",
                                 @"秣周东路/",
                                 @"清水西苑/"
                                 ];
        [self addSubview:taskLineView];
    }
}
-(void)performedView
{

    WCRoadLineView *roadLineView = [[WCRoadLineView alloc]initWithFrame:CGRectMake(tLineViewAndTabDis, tLineViewAndNavDis, 819.5 + 95, 335)];
    roadLineView.roadLineViewType = WCRoadLineViewTypeAllName;
    roadLineView.count = 9;
    [roadLineView settingRoadLine];
    [self addSubview:roadLineView];
}

@end
