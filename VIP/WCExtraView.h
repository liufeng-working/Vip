//
//  WCExtraView.h
//  VIP
//
//  Created by NJWC on 16/3/23.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCExtraView;
@protocol WCExtraViewDelegate <NSObject>

- (void)selectImageWithView:(WCExtraView *)extraView withIndex:(NSInteger)index;

@end

@interface WCExtraView : UIView

/**
 *  接收每次用户选中的图片
 */
@property (nonatomic, strong)UIImage *image;

/**
 *  代理回调
 */
@property (nonatomic, weak)id<WCExtraViewDelegate> delegate;

/**
 *  是否隐藏选择图片的按钮(默认为NO)
 */
@property (nonatomic, assign)BOOL hiddenSelectBtn;

+(instancetype)extraViewWithFrame:(CGRect)frame;

//移除上面的图片
- (void)removeImage;

@end

/**
 *  仅仅继承一下，用于区分
 */
@interface WCImageView : UIImageView

@end
