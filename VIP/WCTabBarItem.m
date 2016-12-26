//
//  WCTabBarItem.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTabBarItem.h"

@interface WCTabBarItem ()

@property(nonatomic,strong)UILabel * badgeLabel;

@end

@implementation WCTabBarItem

-(instancetype)initWithTitle:(NSString *)title withNormalImage:(UIImage *)nImage withSelectImage:(UIImage *)sImage
{
    self = [super init];
    if (self) {
        self.title  = title;
        self.nImage = nImage;
        self.sImage = sImage;
    }
    return self;
}

/**
 *  懒加载
 */
-(UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc]init];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.layer.masksToBounds = YES;
    }
    return _badgeLabel;
}

-(void)setBadgeCount:(NSUInteger)badgeCount
{
    _badgeCount = badgeCount;
    
    if (badgeCount == 0) {
        self.badgeLabel.hidden = YES;
        [self.badgeLabel removeFromSuperview];
    }else{
        NSString * badgeStr;
        if(badgeCount > 99){
            badgeStr = @"99+";
        }else{
            badgeStr = kStringWithFormat(@"%lu",(unsigned long)badgeCount);
        }
        UIFont * font = kSetFont(kMessageFoneSize);
        CGSize size = [badgeStr sizeWithFont:font];
        
        self.badgeLabel.font = font;
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = badgeStr;
        self.badgeLabel.frame = CGRectMake( 0, 0, size.width + 5,size.height);
        self.badgeLabel.center = CGPointMake(kTabBarItemWidth/2.0 + kMarginX, kTabBarItemHeight/2.0 + kMarginY);
        self.badgeLabel.layer.cornerRadius = CGRectGetHeight(self.badgeLabel.frame) / 2.0;
        [self addSubview:self.badgeLabel];
    }
}

//去除点击时的高亮状态
-(void)setHighlighted:(BOOL)highlighted
{}

@end
