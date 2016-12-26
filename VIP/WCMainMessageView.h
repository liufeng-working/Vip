//
//  WCMainMessageView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.

/**************************************
 *所有显示的内容
 **************************************
 *都用这个自定义view
 **************************************
 *传不同的参数来显示不同的内容
 **************************************
*/

typedef NS_ENUM(NSInteger,WCMainViewType){
    
    WCMainViewTypeBasic = 1,   //基本信息
    WCMainViewTypeLine,        //路线设置
    WCMainViewTypePhase,       //相位设置
    WCMainViewTypeContro,      //控制执行
};
#import <UIKit/UIKit.h>

@interface WCMainMessageView : UIView

@property(nonatomic,assign)WCMainViewType mainViewType;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame withType:(WCMainViewType)mainViewType;

//设置视图样式
-(void)settingViewStyle;

@end
