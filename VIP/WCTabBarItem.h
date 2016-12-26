//
//  WCTabBarItem.h
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCTabBarItem : UIButton

/**
 *  每个item的标题
 */
@property(nonatomic,copy)NSString * title;
/**
 *  默认图片
 */
@property(nonatomic,strong)UIImage * nImage;
/**
 *  选中图片
 */
@property(nonatomic,strong)UIImage * sImage;
/**
 *  消息数目
 */
@property(nonatomic,assign)NSUInteger badgeCount;

/**
 *  初始化item
 *
 *  @param title  名字（暂时没写实现部分，传nil）
 *  @param nImage 默认图片
 *  @param sImage 选中图片
 */
-(instancetype)initWithTitle:(NSString *)title withNormalImage:(UIImage *)nImage withSelectImage:(UIImage *)sImage;

@end
