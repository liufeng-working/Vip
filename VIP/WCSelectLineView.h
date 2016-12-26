//
//  WCSelectLineView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCSelectLineViewDelegate <NSObject>

-(void)selectLineWithIndex:(NSInteger)index;

@end

@interface WCSelectLineView : UIView

@property(nonatomic,weak)id<WCSelectLineViewDelegate> delegate;

+(instancetype)selectLineViewWithFrame:(CGRect)frame;

@end
