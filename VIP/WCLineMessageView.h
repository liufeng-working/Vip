//
//  WCLineMessageView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCLineMessage;
@class WCLineMessageView;

@protocol WCLineMessageViewDelegate <NSObject>

-(void)setUserLineBtnClick:(WCLineMessageView *)view;

-(void)otherAreaClick:(WCLineMessageView *)messageView;

@end

@interface WCLineMessageView : UIView

@property (nonatomic, strong)WCLineMessage *message;

@property(nonatomic,weak)id<WCLineMessageViewDelegate> delegate;

/**
 *  应小朱要求，改变边框状态
 */
@property (nonatomic, assign)BOOL backGround;

+(instancetype)lineMessageViewWithFrame:(CGRect)frame;

/**
 *  设为常用路线
 */
- (void)setStatus;

@end


@interface WCLineMessage : NSObject

/**
 *  距离
 */
@property(nonatomic,assign)CGFloat distance;

/**
 *  时间
 */
@property(nonatomic,assign)CGFloat time;

/**
 *  路口数
 */
@property(nonatomic,assign)NSInteger roadCount;

@end
