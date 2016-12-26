//
//  WCStatisticsTopView.h
//  VIP
//
//  Created by NJWC on 16/3/28.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCStatisticsTopViewDelegate <NSObject>

//当时间范围选定后需要通知控制器，去请求指定时间段的数据
-(void)selectDateWithIndex:(NSInteger)index;

//切换表格样式
-(void)changeFormStyleWithIndex:(NSInteger)index;

@end

@interface WCStatisticsTopView : UIView

/**
 *  开始时间
 */
@property (weak, nonatomic) IBOutlet UILabel *startDate;

/**
 *  结束时间
 */
@property (weak, nonatomic) IBOutlet UILabel *endDate;

@property(nonatomic,weak)id<WCStatisticsTopViewDelegate> delegate;

+(instancetype)statisticsTopViewWithFrame:(CGRect)frame;

@end
