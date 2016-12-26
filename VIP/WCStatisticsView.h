//
//  WCStatisticsView.h
//  VIP
//
//  Created by NJWC on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WCStatisticsViewType){
    
    WCStatisticsViewTypeDay = 1,   //日
    WCStatisticsViewTypeWeek,      //周
    WCStatisticsViewTypeMonth,     //月
    WCStatisticsViewTypeYear,      //年
};

@interface WCStatisticsView : UIView

@property(nonatomic,assign)WCStatisticsViewType statisticsViewType;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame withType:(WCStatisticsViewType)statisticsViewType;

//设置视图样式
-(void)settingViewStyle;

@end
