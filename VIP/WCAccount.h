//
//  WCAccount.h
//  VIP
//
//  Created by NJWC on 16/4/5.
//  Copyright © 2016年 wancun. All rights reserved.
/*
 * 登陆参数的model
 */

#import <Foundation/Foundation.h>

@interface WCAccount : NSObject

/**
 *  用户账号
 */
@property (nonatomic, copy)NSString *account;

/**
 *  用户名称
 */
@property (nonatomic, copy)NSString *account_name;

/**
 *  账户类型
 */
@property (nonatomic, assign)NSInteger account_type;

/**
 *  设备编号
 */
@property (nonatomic, copy)NSString *facilityId;

/**
 *  密码
 */
@property (nonatomic, copy)NSString *password;

@end
