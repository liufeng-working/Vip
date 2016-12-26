//
//  WCPopupView.h
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCPopupView;
@protocol WCPopupViewDelegate <NSObject>

- (void)selectWithPopupView:(WCPopupView *)popupView withName:(NSString *)name;

@end

@interface WCPopupView : UIView

@property (nonatomic, strong)NSArray *nameArray;
@property (nonatomic, weak)id<WCPopupViewDelegate> delegate;
@property (nonatomic, assign)NSInteger lastSelectedIndex;

+(instancetype)popupViewWithFrame:(CGRect)frame;

@end
