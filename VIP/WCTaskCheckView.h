//
//  WCTaskCheckView.h
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WCTaskCheckViewType){
    
    WCTaskCheckViewTypePerforming = 1,    //执行中
    WCTaskCheckViewTypePerformWait,       //等待执行
    WCTaskCheckViewTypepeperformed,       //已经执行
};

@interface WCTaskCheckView : UIView

@property(nonatomic,assign)WCTaskCheckViewType taskCheckViewType;

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame withType:(WCTaskCheckViewType)taskCheckViewType;

//设置视图样式
-(void)settingViewStyle;

@end
