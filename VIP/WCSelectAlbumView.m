//
//  WCSelectAlbumView.m
//  VIP
//
//  Created by NJWC on 16/4/7.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCSelectAlbumView.h"

@interface WCSelectAlbumView ()

- (IBAction)selectAlbum:(UIButton *)sender;


@end

@implementation WCSelectAlbumView

+(instancetype)selectAlbumViewFrame:(CGRect)frame
{
    WCSelectAlbumView * selectAlbumView = [[[NSBundle mainBundle] loadNibNamed:@"WCSelectAlbumView" owner:nil options:nil] lastObject];
    selectAlbumView.frame = frame;
    return selectAlbumView;
}

- (IBAction)selectAlbum:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(selectAlbumWithIndex:)]) {
        [_delegate selectAlbumWithIndex:sender.tag];
    }
    
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
