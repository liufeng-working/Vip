//
//  WCTabBarView.m
//  VIP
//
//  Created by NJWC on 16/3/18.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCTabBarView.h"
#import "WCTabBarItem.h"

@interface WCTabBarView()

@property(nonatomic,strong)UIImageView * logoImageView;
@property(nonatomic,strong)WCTabBarItem * lastBtn;

@end
@implementation WCTabBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithHexString:kTabBarBackGroundColor];
        
        //logo图片
        UIImage * logoImage = [UIImage imageNamed:@"logo"];
        CGFloat logoX = (CGRectGetWidth(frame) - logoImage.size.width) / 2.0;
        UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(logoX, kStartY, logoImage.size.width, logoImage.size.height)];
        logoImageView.image = logoImage;
        [self addSubview:logoImageView];
        self.logoImageView = logoImageView;
    }
    return self;
}

-(void)setTabBarItemWithItem:(WCTabBarItem *)item withNormalImage:(UIImage *)normalImage withSelectImage:(UIImage *)selectImage
{
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectImage forState:UIControlStateSelected];
    [item setBackgroundImage:nil forState:UIControlStateNormal];
    [item setBackgroundImage:[UIImage imageNamed:@"tabBar_backGroundImage"] forState:UIControlStateSelected];
    item.tag = self.subviews.count - 1;//减去顶部的logo对象
    [self addSubview:item];
    [item addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.tag == 0) {
        item.selected = YES;
        self.lastBtn = item;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    for (id obj in self.subviews) {
        
        if ([obj isKindOfClass:[WCTabBarItem class]]) {
            
            WCTabBarItem * item = (WCTabBarItem *)obj;
            
            //区分是上面的还是下面的item,分别设置frame
            if (item.tag < 4) {
                item.frame = CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame) + kLogoAndItemDistance + (kItemDistance + kTabBarItemHeight) * item.tag, kTabBarItemWidth, kTabBarItemHeight);
            }else{
                item.frame = CGRectMake(0, CGRectGetMaxY(self.logoImageView.frame) + kLogoAndItemDistance + kTopAndButtomDistance + (kItemDistance + kTabBarItemHeight) * item.tag, kTabBarItemWidth, kTabBarItemHeight);
            }
        }
    }
}

-(void)btnClick:(WCTabBarItem *)sender
{
    //反复点击不做任何操作
    if (self.lastBtn == sender) {
        return;
    }
    
    //设置上个按钮为未选中状态
    self.lastBtn.selected = NO;
    //设置当前按钮为选中状态
    sender.selected = YES;
    //记录下当前按钮
    self.lastBtn = sender;

    //调用代理，回控制器做事情
    if ([_delegate respondsToSelector:@selector(menuClickWithTabBarView:withIndex:)]) {
        [_delegate menuClickWithTabBarView:self withIndex:sender.tag];
    }
}

@end
