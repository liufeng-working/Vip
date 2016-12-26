//
//  WCBigAndSmallView.h
//  VIP
//
//  Created by NJWC on 16/3/24.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCBigAndSmallViewDelegate <NSObject>

-(void)bigAndSmallViewClickWithIndex:(NSInteger)index;

@end

@interface WCBigAndSmallView : UIView

@property(nonatomic,weak)id<WCBigAndSmallViewDelegate> delegate;

+(instancetype)bigAndSmallViewWithFrame:(CGRect)frame;

@end
