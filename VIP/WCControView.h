//
//  WCControView.h
//  VIP
//
//  Created by NJWC on 16/3/31.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCControViewDelegate <NSObject>

-(void)controClickWithIndex:(NSInteger)index;

@end

@interface WCControView : UIView

@property(nonatomic,weak)id<WCControViewDelegate> delegate;

+(instancetype)controViewWithFrame:(CGRect)frame;

@end
