//
//  WCOneBasicViewController.h
//  VIP
//
//  Created by NJWC on 16/4/1.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCBasicBaseViewController.h"
#import <Foundation/Foundation.h>

@class WCCarMessage;
@interface WCOneBasicViewController : WCBasicBaseViewController

/**
 *  image
 */
@property (nonatomic, strong)NSMutableArray *imageArray;

/**
 *  车辆信息，第四个页面会用到的
 */
@property (nonatomic, strong)WCCarMessage *carMessage;

/**
 *  上传成功后，返回的url（感觉多此一举，没必要上传服务器的）
 */
@property (nonatomic, strong)NSMutableArray *imgUrl;

@end

