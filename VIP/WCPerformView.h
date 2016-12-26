//
//  WCPerformView.h
//  VIP
//
//  Created by NJWC on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCPerformView : UIView

/**
 *  路口名
 */
@property (nonatomic, strong)NSArray *nameArr;

/**
 *  详细的相位名字
 */
@property (nonatomic, strong)NSArray *detailNameArr;

/**
 *  当前的地点（1 表示第一个地点）
 */
@property (nonatomic, assign)NSInteger index;

/**
 *  开始描绘路线（感觉这样的代码非常搓，效率非常非常低，但是没想到好的办法，先就这样*吧，实现了再说）
 */
-(void)startDrawLine;
@end
