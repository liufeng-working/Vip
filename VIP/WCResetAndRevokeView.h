//
//  WCResetAndRevokeView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCResetAndRevokeViewDelegate <NSObject>

-(void)resetAndRevokeWithIndex:(NSInteger)index;

@end

@interface WCResetAndRevokeView : UIView

@property(nonatomic,weak)id<WCResetAndRevokeViewDelegate> delegate;

+(instancetype)resetAndRevokeViewWithFrame:(CGRect)frame;

@end
