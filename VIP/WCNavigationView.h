//
//  WCNavigationView.h
//  VIP
//
//  Created by NJWC on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WCNavigationViewType){
    
    WCNavigationViewTypeBasic = 1, //基础信息中用
    WCNavigationViewTypeTask,      //任务监控中用
    WCNavigationViewTypeCount,     //数据统计中用
    
    WCNavigationViewTypePerformTask,//任务监控页面的 任务执行中用
};

@class WCNavigationView;
@protocol WCNavigationViewDelegate <NSObject>
@optional
//基础信息页面，点击了左右按钮的回调方法
- (void)leftButtonClick;
- (void)rightButtonClick;

//任务检测页面，点击了某个按钮的回调方法
-(void)taskButtonClickWithNagivationView:(WCNavigationView *)navigationView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

//数据统计页面，点击了某个按钮的回调方法
-(void)dateButtonClickWithNagivationView:(WCNavigationView *)navigationView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

//任务执行页面，点击了返回按钮，终止按钮回调方法
-(void)backButtonClickWithNagivationView:(WCNavigationView *)navigationView;
-(void)stopButtonClickWithNagivationView:(WCNavigationView *)navigationView;

@end

@class WCNavigationButton;
@interface WCNavigationView : UIView
/**
 *  view的类型
 */
@property(nonatomic,assign)WCNavigationViewType navigationViewType;

/**
 *  是第几个页面
 */
@property (nonatomic, assign)NSInteger index;

/**
 *  代理
 */
@property(nonatomic,weak)id<WCNavigationViewDelegate> delegate;
/**
 *  标题
 */
@property(nonatomic,strong)NSArray * titleArray;

@end

