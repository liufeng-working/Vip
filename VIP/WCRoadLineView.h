//
//  WCRoadLineView.h
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WCRoadLineViewType) {
    WCRoadLineViewTypeSenvenName = 1,  //只展示7个以下
    WCRoadLineViewTypeAllName,         //展示所有地点名字
    
    WCRoadLineViewTypeHasProgress,     //可以设置进度(针对只显示7个及以下)
};

@interface WCRoadLineView : UIView

/**
 *  路线上所有地点的名字
 */
@property(nonatomic,strong)NSArray<NSString *> * nameArr;
/**
 *  路线展示的样式（默认是只展示7个）
 */
@property(nonatomic,assign)WCRoadLineViewType roadLineViewType;
/**
 *  每行显示的个数（针对展示所有名字的路线，默认为7）
 */
@property(nonatomic,assign)NSInteger count;

/**
 *  设置进度（针对WCRoadLineViewTypeHasProgress类型 1表示第一个）
 */
@property (nonatomic, assign)NSInteger index;

/**
 *  开始画路线
 */
- (void)settingRoadLine;

@end
