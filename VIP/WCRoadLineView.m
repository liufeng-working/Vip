//
//  WCRoadLineView.m
//  VIP
//
//  Created by NJWC on 16/3/25.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCRoadLineView.h"
#import "WCProgressView.h"


//#define lineProX 43 //第一个圈的x坐标
#define lineProY 15 //第一个圈的y坐标
#define lineProDis 70 //圈圈之间的距离
#define lineProAndTitleDis 10 //圈圈和标题之间的距离
#define lineTitleSize 12 //标题的大小

@interface WCRoadLineView ()

@property(nonatomic,strong)NSMutableArray * nameArray;
@property(nonatomic,strong)NSMutableArray * numArray;
@property(nonatomic,strong)NSMutableArray * pointArr;

@property (nonatomic, strong)NSMutableArray *proImageArr;
@property (nonatomic, strong)NSMutableArray *titleLabelArr;
@property (nonatomic, strong)NSMutableArray *progressViewArr;

@end

@implementation WCRoadLineView

//手动创建的view
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.nameArr = @[
                        @"测试名字",
                        @"测试名字",
                        @"测试名字",
                        @"测试名字",
                        @"测试名字",
                        @"测试名字",
                        @"测试名字"
                        ];
        //默认
        self.roadLineViewType = WCRoadLineViewTypeSenvenName;
        //默认
        self.count = 7;
    }
    return self;
}

//懒加载
-(NSMutableArray *)nameArray
{
    if (!_nameArray) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}

-(NSMutableArray *)numArray
{
    if (!_numArray) {
        _numArray = [NSMutableArray array];
    }
    return _numArray;
}

-(NSMutableArray *)pointArr
{
    if (!_pointArr) {
        _pointArr = [NSMutableArray array];
    }
    return _pointArr;
}

-(NSMutableArray *)proImageArr
{
    if (!_proImageArr) {
        _proImageArr = [NSMutableArray array];
    }
    return _proImageArr;
}

-(NSMutableArray *)titleLabelArr
{
    if (!_titleLabelArr) {
        _titleLabelArr = [NSMutableArray array];
    }
    return _titleLabelArr;
}

-(NSMutableArray *)progressViewArr
{
    if (!_progressViewArr) {
        _progressViewArr = [NSMutableArray array];
    }
    return _progressViewArr;
}

/**
 *设置路线，根据个数，设置不同样式
 */
- (void)settingRoadLine
{
    for (UIView *v  in self.subviews) {
        [v removeFromSuperview];
    }
    
    //重用前，需要清空原来的数据
    if(self.roadLineViewType == WCRoadLineViewTypeHasProgress){
        [self.proImageArr removeAllObjects];
        [self.titleLabelArr removeAllObjects];
        [self.progressViewArr removeAllObjects];
        [self.nameArray removeAllObjects];
        [self.numArray removeAllObjects];
        [self.pointArr removeAllObjects];
        
    }
    
    //准备必要的信息
    [self getMessage];
    
    //占用的高度
    // 92 + (70 + 22)*(行数 - 1)
    
    //圈圈
    UIImage *progressBarImg = [UIImage imageNamed:@"progress-bar_spot2_focusing"];
    UIImage *progressBackImg = [UIImage imageNamed:@"progress-bar_spot2"];
    CGFloat pW = progressBarImg.size.width;
    CGFloat pH = progressBarImg.size.height;
    
    CGFloat startX = (self.width - self.count * pW - (self.count - 1) * lineProDis) / 2.0;
    
    //开始布局界面
    for (NSInteger i = 0; i < self.nameArray.count; i++)
    {
        NSInteger Y = i / self.count;
        NSInteger X = labs(i % self.count - Y % 2 * (self.count - 1));

        UIImageView * pImgView = [[UIImageView alloc]initWithFrame:CGRectMake(startX + (pW + lineProDis) * X, lineProY + (pH + lineProDis) * Y, pW, pH)];
        
        [self addSubview:pImgView];
        
        if (self.roadLineViewType == WCRoadLineViewTypeAllName |
            self.roadLineViewType == WCRoadLineViewTypeSenvenName ) {
            //记录下这些圈圈的中心点
            NSValue *pointValue = [NSValue valueWithCGPoint:pImgView.center];
            [self.pointArr addObject:pointValue];
            pImgView.image = progressBarImg;
        }else{
            [self.proImageArr addObject:pImgView];
            pImgView.image = progressBackImg;
        }
        
        //数字
        UILabel * numL = [[UILabel alloc]initWithFrame:pImgView.bounds];
        numL.text = _numArray[i];
        numL.layer.cornerRadius = pW / 2.0;
        numL.layer.masksToBounds = YES;
        numL.backgroundColor = [UIColor clearColor];
        numL.textAlignment = NSTextAlignmentCenter;
        numL.textColor = [UIColor colorWithHexString:@"FFFFFF"];
        numL.font = kSetFont(10);
        [pImgView addSubview:numL];
        
        //地名
        NSString * titleStr = self.nameArray[i];
        UIFont * font = kSetFont(lineTitleSize);
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
        
        //确定标题显示的位置
        CGPoint center;
        if(((i + 1) % self.count == 0) &&
           (Y % 2 == 1) &&
           (i + 1 < self.nameArray.count)){
            
            center = CGPointMake(pImgView.centerX - (pImgView.width / 2.0 + titleLabel.width) / 2.0, pImgView.bottom + titleLabel.height/2.0 + lineProAndTitleDis);
        }else if (((i + 1) % self.count == 0) &&
                  (Y % 2 == 0) &&
                  (i + 1 < self.nameArray.count)){
            
            center = CGPointMake(pImgView.centerX + (pImgView.width / 2.0 + titleLabel.width) / 2.0, pImgView.bottom + titleLabel.height/2.0 + lineProAndTitleDis);
        }else{
            
            center = CGPointMake(pImgView.centerX, pImgView.bottom + titleLabel.height/2.0 + lineProAndTitleDis);
        }
        
        titleLabel.center = center;
        titleLabel.numberOfLines = 2;
        titleLabel.font = font;
        titleLabel.text = titleStr;
        if (self.roadLineViewType == WCRoadLineViewTypeAllName |
            self.roadLineViewType == WCRoadLineViewTypeSenvenName) {
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleSelectColor];
        }else{
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleNormalColor];
        }
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        if (self.roadLineViewType == WCRoadLineViewTypeHasProgress) {
            [self.titleLabelArr addObject:titleLabel];
        }
        
        //进度条
        if (self.roadLineViewType == WCRoadLineViewTypeHasProgress |
            self.roadLineViewType == WCRoadLineViewTypeSenvenName) {
            if (i < (self.nameArray.count - 1)) {
                WCProgressView * progressView = [[WCProgressView alloc]initWithFrame:CGRectMake(pImgView.right, pImgView.top + (pImgView.height - bProgressHeight) / 2.0, lineProDis / 2.0, bProgressHeight)];
                progressView.backgroundColor = [UIColor colorWithHexString:kProgressTintColor];
                [self addSubview:progressView];
                [self.progressViewArr addObject:progressView];
                
                WCProgressView * progressView1 = [[WCProgressView alloc]initWithFrame:CGRectMake(progressView.right, pImgView.top + (pImgView.width - bProgressHeight) / 2.0, lineProDis / 2.0, bProgressHeight)];
                progressView1.backgroundColor = [UIColor colorWithHexString:kProgressTintColor];
                [self addSubview:progressView1];
                
                [self.progressViewArr addObject:progressView1];
            }
        }
    }
    
    if (self.roadLineViewType == WCRoadLineViewTypeAllName) {
        
        [self setNeedsDisplay];
    }
}

-(void)getMessage
{
    //赋值给内部变量
    self.nameArray = [self.nameArr mutableCopy];
    
    //设置数字的数组
    for (NSInteger i = 0; i < _nameArray.count; i ++)
    {
        [self.numArray addObject:kStringWithFormat(@"%ld",(long)(i + 1))];
    }
    
    if (self.roadLineViewType == WCRoadLineViewTypeSenvenName |
        self.roadLineViewType == WCRoadLineViewTypeHasProgress) {
        
        //如果多于7个，就保留7个
        if (_nameArray.count > self.count) {
            
            NSInteger lastNum = _nameArray.count - 6;
            NSRange removeRange = NSMakeRange(3, lastNum);
            //取出前后三个元素 在中间增加一个元素（... ...）
            [_nameArray removeObjectsInRange:removeRange];
            [_nameArray insertObject:@"... ..." atIndex:3];
            //取出前后三个元素 在中间增加一个元素（...）
            [_numArray removeObjectsInRange:removeRange];
            [_numArray insertObject:@"..." atIndex:3];
        }
    }
}

-(void)drawRect:(CGRect)rect
{
    if (self.pointArr.count <= 1) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < self.pointArr.count; i ++)
    {
        CGPoint point = [self.pointArr[i] CGPointValue];
        if (i == 0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }
    path.lineWidth = bProgressHeight;
    [[UIColor colorWithHexString:kProgressTintColor] set];
    [path stroke];
}

//设置进度
-(void)setIndex:(NSInteger)index
{
    if(self.roadLineViewType != WCRoadLineViewTypeHasProgress |
       index < 0){
        return;
    }
    _index = index;
    
    //转换成内部的序号
    NSInteger inIndex;
    
    if (index <= 3) {
        
        inIndex = index;
    }else if(index <= self.nameArr.count - 3){
        
        inIndex = 4;
    }else if(index <= self.nameArr.count){
        
        inIndex = index - (self.nameArr.count - 7);
    }else{
        
        inIndex = 7;
    }
    
    for (NSInteger i = 0; i < self.nameArray.count; i++)
    {
        UIImageView * pImgView = _proImageArr[i];
        UILabel * titleLabel = _titleLabelArr[i];
        if (i < inIndex) {
            
            pImgView.image = [UIImage imageNamed:@"progress-bar_spot2_focusing"];
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleSelectColor];
            
        }else{
            
            pImgView.image = [UIImage imageNamed:@"progress-bar_spot2"];
            titleLabel.textColor = [UIColor colorWithHexString:bNavTitleNormalColor];
            
        }
    }
    
    NSInteger progressNum = 2 * inIndex - 1;
    
    for (NSInteger i = 0; i < _progressViewArr.count; i ++)
    {
        UIView * progressView = _progressViewArr[i];
        if (i < progressNum) {
            
            progressView.backgroundColor = [UIColor colorWithHexString:kProgressTintColor];
        }else{
            progressView.backgroundColor = [UIColor colorWithHexString:kProgressBackColor];
        }
    }
}

@end
