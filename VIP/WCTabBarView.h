//
//  WCTabBarView.h
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
/*
 自定义tabbar视图
 */

#import <UIKit/UIKit.h>

@class WCTabBarView;
@class WCTabBarItem;
@protocol WCTabBarViewDelegate <NSObject>
//代理回调，把用户点击的按钮的序号传回去
-(void)menuClickWithTabBarView:(WCTabBarView *)tabBarView withIndex:(NSUInteger)index;

@end

@interface WCTabBarView : UIView

//代理
@property(nonatomic,weak)id<WCTabBarViewDelegate> delegate;

//设置每个item的默认图片和选中图片
-(void)setTabBarItemWithItem:(WCTabBarItem *)item withNormalImage:(UIImage *)normalImage withSelectImage:(UIImage *)selectImage;

@end
