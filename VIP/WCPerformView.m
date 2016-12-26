//
//  WCPerformView.m
//  VIP
//
//  Created by NJWC on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCPerformView.h"

@interface WCPerformView ()

//底部的scrollView
@property (nonatomic, strong)UIScrollView *bgScroll;

//圈圈imageView 数组
@property (nonatomic, strong)NSMutableArray *bgImgArr;

//进度条数组
@property (nonatomic, strong)NSMutableArray *proArr;

//大标题数组
@property (nonatomic, strong)NSMutableArray *titleArr;

//小标题数组
@property (nonatomic, strong)NSMutableArray *detailArr;

@end

@implementation WCPerformView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.bgScroll];
        
    }
    return self;
}

-(UIScrollView *)bgScroll
{
    if (!_bgScroll) {
        _bgScroll = [[UIScrollView alloc]initWithFrame:self.bounds];
        _bgScroll.showsVerticalScrollIndicator = NO;
        _bgScroll.showsHorizontalScrollIndicator = NO;
    }
    return _bgScroll;
}

-(NSMutableArray *)bgImgArr
{
    if (!_bgImgArr) {
        _bgImgArr = [NSMutableArray array];
    }
    return _bgImgArr;
}

-(NSMutableArray *)proArr
{
    if (!_proArr) {
        _proArr = [NSMutableArray array];
    }
    return _proArr;
}

-(NSMutableArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    return _titleArr;
}

-(NSMutableArray *)detailArr
{
    if (!_detailArr) {
        _detailArr = [NSMutableArray array];
    }
    return _detailArr;
}

-(void)setNameArr:(NSArray *)nameArr
{
    _nameArr = nameArr;
    
    self.bgScroll.contentSize = CGSizeMake(self.width, nameArr.count * 76);
}

-(void)startDrawLine
{
    //圈圈
    UIImage *progressBarImg = [UIImage imageNamed:@"progress-bar_spot2"];
    CGFloat pW = progressBarImg.size.width;
    CGFloat pH = progressBarImg.size.height;
    
    CGFloat startX = 20;
    CGFloat startY = 27;
    CGFloat dis = 54;
    
    //开始布局界面
    for (NSInteger i = 0; i < self.nameArr.count; i++)
    {
        //圈圈
        UIImageView * pImgView = [[UIImageView alloc]initWithFrame:CGRectMake(startX, startY + (pH + dis) * i, pW, pH)];
        pImgView.image = progressBarImg;
        [self.bgScroll addSubview:pImgView];
        [self.bgImgArr addObject:pImgView];//圈圈
        //数字
        UILabel * numL = [[UILabel alloc]initWithFrame:pImgView.bounds];
        numL.text = kStringWithFormat(@"%ld",(long)(i + 1));
        numL.layer.cornerRadius = pW / 2.0;
        numL.layer.masksToBounds = YES;
        numL.backgroundColor = [UIColor clearColor];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        numL.font = kSetFont(10);
        [pImgView addSubview:numL];
        
        //地名
        //大标题
        CGFloat dis1 = 20;
        UIFont * font1 = kSetFont(15);
        CGFloat h1 = font1.lineHeight;
        UILabel * titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(pImgView.right + dis1, pImgView.centerY - 4.5 - h1, self.bgScroll.width - dis1 * 2 - pImgView.right, h1)];
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.font = font1;
        titleLabel1.text = self.nameArr[i];
        titleLabel1.textColor = [UIColor colorWithHexString:@"#8899AA"];
        titleLabel1.textAlignment = NSTextAlignmentLeft;
        [self.bgScroll addSubview:titleLabel1];
        [self.titleArr addObject:titleLabel1];
        
        //小标题
        UIFont * font2 = kSetFont(12);
        CGFloat h2 = font2.lineHeight;
        UILabel * titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel1.left, titleLabel1.bottom + 9, titleLabel1.width, h2)];
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.font = font2;
        titleLabel2.text = self.detailNameArr[i];;
        titleLabel2.textColor = [UIColor colorWithHexString:@"#8899AA"];
        titleLabel2.textAlignment = NSTextAlignmentLeft;
        [self.bgScroll addSubview:titleLabel2];
        [self.detailArr addObject:titleLabel2];
        
        
        if (i != self.nameArr.count - 1) {
            //分割线
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(titleLabel2.left, pImgView.centerY + pH / 2.0 + dis / 2.0, titleLabel2.width, 1)];
            lineView.alpha = 0.1;
            lineView.backgroundColor = [UIColor colorWithHexString:@"#8899AA"];
            [self.bgScroll addSubview:lineView];
            
            //进度条
            UIView *progressView = [[UIView alloc]initWithFrame:CGRectMake(0, pImgView.bottom, 3.5, 54)];
            progressView.centerX = pImgView.centerX;
            progressView.backgroundColor = [UIColor colorWithHexString:kProgressBackColor];
            [self.bgScroll addSubview:progressView];
            [self.proArr addObject:progressView];
        }
    }
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
    if (index <= 0 | index >= self.nameArr.count) {
        return;
    }
    
    //疯狂的for循环啊（万一有上万个数据，怕会循环致死啊）
    for (NSInteger i = 1; i < self.nameArr.count + 1; i ++)
    {
        UIImageView *pImg = self.bgImgArr[i - 1];
        UILabel *titleLabel = self.titleArr[i - 1];
        UILabel *detailLabel = self.detailArr[i - 1];
        
        UIView *proView;
        if (i < self.nameArr.count) {
            proView = self.proArr[i - 1];
        }
        
        if (i < index) {
            pImg.image = [UIImage imageNamed:@"progress-bar_spot2_focusing"];
            titleLabel.textColor = [UIColor colorWithHexString:@"#334455"];
            detailLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
            proView.backgroundColor = [UIColor colorWithHexString:kProgressTintColor];
        }else if (i == index){
            pImg.image = [UIImage imageNamed:@"progress-bar_spot2_focusing"];
            titleLabel.textColor = [UIColor colorWithHexString:@"#3597DB"];
            detailLabel.textColor = [UIColor colorWithHexString:@"#3597DB"];
            proView.backgroundColor = [UIColor colorWithHexString:kProgressBackColor];
        }else{
            pImg.image = [UIImage imageNamed:@"progress-bar_spot2"];
            titleLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
            detailLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
            proView.backgroundColor = [UIColor colorWithHexString:kProgressBackColor];
        }
    }
}

@end
