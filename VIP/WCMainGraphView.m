//
//  WCMainGraphView.m
//  VIP
//
//  Created by NJWC on 16/4/13.
//  Copyright © 2016年 wancun. All rights reserved.
//

#import "WCMainGraphView.h"

@interface WCMainGraphView ()
{
    float _leftMargin;
    float _rightMargin;
}

//左边y轴最大值
@property (nonatomic, assign)NSInteger leftMaxY;

//右边y轴最大值
@property (nonatomic, assign)NSInteger rightMaxY;

//所有点
@property (nonatomic,strong) NSMutableArray *xPoints;

@end

#define TOP 20 //顶部留白
#define LEFT 20 //左边留白
#define BOTTOM 60 //下面留白
#define RIGHT 20 //右边留白
#define COUNT 7 //y轴展示几等分

@implementation WCMainGraphView

-(void)setXValues:(NSArray *)xValues
{
    
    NSMutableArray *arr = [NSMutableArray array];
    if (xValues.count > 7) {
        for (NSInteger i = 6; i >= 0; i --)
        {
            [arr addObject:xValues[xValues.count - 1 - i]];
        }
    }else{
        arr = [xValues mutableCopy];
    }
    _xValues = arr;
}

-(void)setPrioIntNumArr:(NSArray *)prioIntNumArr
{
    _prioIntNumArr = prioIntNumArr;
    NSInteger maxNum = 0;
    for (NSInteger i = 0; i < prioIntNumArr.count; i ++)
    {
        NSNumber * num = prioIntNumArr[i];
        
        //得到一组数据的最大值
        if ([num integerValue] >= maxNum) {
            maxNum = [num integerValue];
        }
    }
    
    //y轴显示的最大值
    self.leftMaxY = (maxNum/COUNT + 1) * COUNT;
}

-(void)setSaveTimeArr:(NSArray *)saveTimeArr
{
    _saveTimeArr = saveTimeArr;
    NSInteger maxNum = 0;
    for (NSInteger i = 0; i < saveTimeArr.count; i ++)
    {
        NSNumber * num = saveTimeArr[i];
        
        //得到一组数据的最大值
        if ([num integerValue] >= maxNum) {
            maxNum = [num integerValue];
        }
    }
    
    //y轴显示的最大值
    self.rightMaxY = (maxNum/COUNT + 1) * COUNT;
}

-(NSMutableArray *)xPoints
{
    if (!_xPoints) {
        _xPoints = [NSMutableArray array];
    }
    return _xPoints;
}

/**
 *  *****************开始画图******************
 */
-(void)drawGraph
{
    if (self.xValues.count <= 0) {
        return;
    }
    
    //画左边y轴
    [self drawLeftYLabels];
    
    //画右边y轴
    [self drawRightYLabels];
    
    //画x轴
    [self drawXLabels];
    
    //画横竖线
    [self drawLineXY];

    
    //画内容
    //柱状图
    [self drawBar];
    
    //折线图
    [self drawLine];
    
    //最下方的标记
    [self drawTip];
}
/**
 *  ******************************************
 */

-(void)drawLeftYLabels
{
    //显示的最大值
    NSInteger maxY = self.leftMaxY;
    //每份的数值是多少
    NSInteger yIntervalValue = maxY / COUNT;
    
    //每段占据高度是多少
    double intervalInPx = (self.height - BOTTOM - TOP) / COUNT;
    
    NSMutableArray *labelArray = [NSMutableArray array];
    float maxWidth = 0;
    
    for(int i = 1; i <= COUNT; i++){
        CGPoint currentLinePoint = CGPointMake(_leftMargin, TOP + i * intervalInPx);
        
        //y轴每个标题的位置
        CGRect lableFrame = CGRectMake(0, currentLinePoint.y , 100, intervalInPx);
        
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:lableFrame];
        yAxisLabel.backgroundColor = [UIColor clearColor];
        yAxisLabel.font = [UIFont systemFontOfSize:12];
        yAxisLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
        yAxisLabel.textAlignment = NSTextAlignmentCenter;
        float val = yIntervalValue * (COUNT  - i);
        //显示
        yAxisLabel.text = [NSString stringWithFormat:@"%.f", val];
        
        //适应大小，重新设置位置
        [yAxisLabel sizeToFit];
        yAxisLabel.frame = CGRectMake(0, yAxisLabel.top - yAxisLabel.height / 2.0, yAxisLabel.width, yAxisLabel.height);
        
        if(yAxisLabel.width > maxWidth) {
            maxWidth = yAxisLabel.width;
        }
        
        //把所有的label装进数组
        [labelArray addObject:yAxisLabel];
        [self addSubview:yAxisLabel];
    
    }
    
    
    //为了美观增加一部分宽度，再次重新设定坐标
    _leftMargin = maxWidth + LEFT;
    
    for( UILabel *l in labelArray) {
        
        l.frame = CGRectMake(0, l.top, _leftMargin, l.height);;
    }
}

-(void)drawRightYLabels
{
    //显示的最大值
    NSInteger maxY = self.rightMaxY;
    //每份的数值是多少
    NSInteger yIntervalValue = maxY / COUNT;
    
    //每段占据高度是多少
    double intervalInPx = (self.height - BOTTOM - TOP) / COUNT;
    
    NSMutableArray *labelArray = [NSMutableArray array];
    float maxWidth = 0;
    
    for(int i = 1 ; i <= COUNT; i++){
        CGPoint currentLinePoint = CGPointMake(_rightMargin, i * intervalInPx + TOP);
        
        //y轴每个标题的位置
        CGRect lableFrame = CGRectMake(0, currentLinePoint.y, 100, intervalInPx);
        
        
        UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:lableFrame];
        yAxisLabel.backgroundColor = [UIColor clearColor];
        yAxisLabel.font = [UIFont systemFontOfSize:12];
        yAxisLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
        yAxisLabel.textAlignment = NSTextAlignmentCenter;
        float val = yIntervalValue * (COUNT - i);
        //显示
        yAxisLabel.text = [NSString stringWithFormat:@"%.f", val];
        
        //适应大小，重新设置位置
        [yAxisLabel sizeToFit];
        yAxisLabel.frame = CGRectMake(0, yAxisLabel.top - yAxisLabel.height / 2.0, yAxisLabel.width, yAxisLabel.height);
        
        if(yAxisLabel.width > maxWidth) {
            maxWidth = yAxisLabel.width;
        }
        
        //把所有的label装进数组
        [labelArray addObject:yAxisLabel];
        [self addSubview:yAxisLabel];
    }
    
    
    //为了美观增加一部分宽度，再次重新设定坐标
    _rightMargin = maxWidth + RIGHT;
    
    for( UILabel *l in labelArray) {

        l.frame = CGRectMake(self.width - _rightMargin, l.top, _rightMargin, l.height);
    }
}

-(void)drawXLabels
{
    //x轴个数
    NSInteger xIntervalCount = _xValues.count;
    
    //每一部分占用的宽度
    double xIntervalInPx = (self.width - _leftMargin - _rightMargin) / xIntervalCount;
    
    for(int i = 0; i < xIntervalCount; i++){
        //每一点的起始坐标
        CGPoint currentLabelPoint = CGPointMake(xIntervalInPx * i + _leftMargin, self.height - BOTTOM);
    
        //每一点具体的位置
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x , currentLabelPoint.y, xIntervalInPx, 35);
        
        //显示内容的lebel
        UILabel *xAxisLabel = [[UILabel alloc] initWithFrame:xLabelFrame];
        xAxisLabel.numberOfLines = 2;
        xAxisLabel.backgroundColor = [UIColor clearColor];
        
        xAxisLabel.font = [UIFont systemFontOfSize:13];
        
        xAxisLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
        xAxisLabel.textAlignment = NSTextAlignmentCenter;
        
        NSString *date = [_xValues objectAtIndex:i];
        //处理时间显示（20160728—>07/28）
        NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
        NSString *day = [date substringWithRange:NSMakeRange(6, 2)];
        
        xAxisLabel.text = [NSString stringWithFormat:@"%@/%@", month, day];
        [self addSubview:xAxisLabel];
        
        CGPoint topCenter = CGPointMake(xAxisLabel.centerX, xAxisLabel.top);
        [self.xPoints addObject:[NSValue valueWithCGPoint:topCenter]];
    }
}

-(void)drawLineXY
{
    //准备一个形状layer
    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = [UIColor colorWithHexString:@"#F3F7F8"].CGColor;
    linesLayer.lineWidth = 1;
    
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    
    
    CGPathMoveToPoint(linesPath, NULL, _leftMargin, TOP);
    CGPathAddLineToPoint(linesPath, NULL, _leftMargin, self.height - BOTTOM);
    CGPathAddLineToPoint(linesPath, NULL, self.width - _rightMargin, self.height - BOTTOM);
    CGPathAddLineToPoint(linesPath, NULL, self.width - _rightMargin, TOP);
    
    linesLayer.path = linesPath;
    [self.layer addSublayer:linesLayer];
    CGPathRelease(linesPath);
}

-(void)drawBar
{
    CAShapeLayer *barLayer = [CAShapeLayer layer];
    barLayer.frame = self.bounds;
    barLayer.lineWidth = 20;
    barLayer.fillColor = [UIColor clearColor].CGColor;
    barLayer.backgroundColor = [UIColor clearColor].CGColor;
    barLayer.strokeColor = [UIColor colorWithHexString:@"#9ACBED"].CGColor;
    UIBezierPath *barPath = [UIBezierPath bezierPath];
    
    
    //计算出每段占的份量
    double yRange = self.leftMaxY;
    //y轴高度
    double height = self.height - BOTTOM - TOP;
    for (NSInteger i = 0; i < _xValues.count; i ++)
    {
        NSInteger values = [_prioIntNumArr[i] integerValue];
        double y = height - values / yRange * height + TOP;
        [barPath moveToPoint:[_xPoints[i] CGPointValue]];
        [barPath addLineToPoint:CGPointMake([_xPoints[i] CGPointValue].x, y)];
    }
    barLayer.path = barPath.CGPath;
    [self.layer addSublayer:barLayer];
}

-(void)drawLine
{
    //圆圈的图层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.frame = self.bounds;
    circleLayer.fillColor = [UIColor colorWithHexString:@"#FFFFFF"].CGColor;
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor =[UIColor colorWithHexString:@"#3597DB"].CGColor;
    circleLayer.lineWidth = 3.5;
    //新建一个路径
    CGMutablePathRef circlePath = CGPathCreateMutable();
    
    
    //折线的图层
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = self.bounds;
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor clearColor].CGColor;
    [graphLayer setStrokeColor:[UIColor colorWithHexString:@"3597DB"].CGColor];
    graphLayer.lineWidth = 3.5;
    //又新建一个路径
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    //计算出每段占的份量
    double yRange = self.rightMaxY;
    //y轴高度
    double height = self.height - BOTTOM - TOP;
    
    //移动到下一个点
    NSInteger count = _xValues.count;
    for(int i=0; i< count; i++){
        
        NSInteger values = [_saveTimeArr[i] integerValue];
        double y = height - values / yRange * height + TOP;
        if (i == 0) {
            //起始点
            CGPathMoveToPoint(graphPath, NULL, [_xPoints[i] CGPointValue].x, y);
        }else{
            CGPathAddLineToPoint(graphPath, NULL, [_xPoints[i] CGPointValue].x, y);
        }
        
        CGPathAddEllipseInRect(circlePath, NULL, CGRectMake([_xPoints[i] CGPointValue].x - 4, y - 4, 8, 8));
    }
    
    //给图层的路径赋值
    graphLayer.path = graphPath;
    circleLayer.path = circlePath;
    
    //释放
    CGPathRelease(circlePath);
    CGPathRelease(graphPath);
    
    //给折线加一个动画（需要的时候，加钱 打开注释）
    /*  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
     animation.duration = 1;
     animation.fromValue = @(0.0);
     animation.toValue = @(1.0);
     [graphLayer addAnimation:animation forKey:@"strokeEnd"];
     */
    //layer的显示先后顺序
    graphLayer.zPosition = 1;
    circleLayer.zPosition = 2;
    
    //添加子图层
    [self.layer addSublayer:graphLayer];
    [self.layer addSublayer:circleLayer];
}

-(void)drawTip
{
    for (NSInteger i = 0; i < 2; i ++)
    {
        NSString *name ;
        if (i == 0) {
            name = @"途经路口";
        }else{
            name = @"节约时间";
        }
        
        UIFont *font = [UIFont systemFontOfSize:13.5];
        CGSize size = [name sizeWithFont:font];
        
        CGFloat startX = (self.width - (20 + 6 + size.width) * 2 - 23) / 2.0;
        UIView *fView = [[UIView alloc]initWithFrame:CGRectMake(startX + (20 + 6 + size.width + 23) * i, self.height - 25 + (25 - 3.5) / 2.0, 20, 3.5)];
        fView.backgroundColor = i == 0 ? [UIColor colorWithHexString:@"#9ACBED"] : [UIColor colorWithHexString:@"#3597DB"];
        [self addSubview:fView];
        
        UILabel *fLabel = [[UILabel alloc]initWithFrame:CGRectMake(fView.right + 6, fView.top + (fView.height - size.height) / 2.0, size.width, size.height)];
        fLabel.textColor = [UIColor colorWithHexString:@"#8899AA"];
        fLabel.textAlignment = NSTextAlignmentCenter;
        fLabel.font = font;
        fLabel.text = name;
        [self addSubview:fLabel];
    }
}


@end
