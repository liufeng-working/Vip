//
//  WCSelectAlbumView.h
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCSelectAlbumViewDelegate <NSObject>

- (void)selectAlbumWithIndex:(NSInteger)index;

@end

@interface WCSelectAlbumView : UIView

@property (nonatomic, weak)id<WCSelectAlbumViewDelegate> delegate;

+(instancetype)selectAlbumViewFrame:(CGRect)frame;

@end
