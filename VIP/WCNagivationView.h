//
//  WCNagivationView.h
//  VIP
//
//  Created by NJWC on 16/3/22.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WCNagivationViewType){
    
    WCNagivationViewTypeBasic = 1, //基础信息中用
    WCNagivationViewTypeTask,      //任务监控中用
    WCNagivationViewTypeCount,     //数据统计中用
};

@class WCNagivationButton;
@interface WCNagivationView : UIView
/**
 *  view的类型
 */
@property(nonatomic,assign)WCNagivationViewType nagivationViewType;

#pragma mark - ****基础信息使用****
/**
 *  上一步按钮
 */
@property(nonatomic,strong)WCNagivationButton * leftButton;
/**
 *  下一步按钮
 */
@property(nonatomic,strong)WCNagivationButton * rightButton;

#pragma mark - ****任务监控中用****

#pragma mark - ****数据统计中使用****

@end

@interface WCNagivationButton : UIButton

@end
