//
//  WCDeviceDirectionTool.h
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCDeviceDirectionTool : NSObject

/**
 *  是否为竖屏
 */
@property (nonatomic, assign)BOOL isVertical;

+ (instancetype)shareDeviceDirection;

/**
 * 为了进度，不行新建一个单例，所以把这个属性附加到这个单例中，其实和这个单例没有任何关系，只是借助这个单例而已
 */
@property (nonatomic, assign)NSInteger index;

@end
