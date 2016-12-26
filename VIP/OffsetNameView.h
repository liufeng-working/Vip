//
//  OffsetNameView.h
//  VIP
//
//  Created by 万存 on 16/3/29.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureBlock)();

@interface OffsetNameView : UIView


+(void) showOffestWithData:(NSArray *)data withIndex:(NSInteger)index SureBlock:(SureBlock) sure;

@property ( nonatomic ,copy) SureBlock sure ;

@end
