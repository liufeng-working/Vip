//
//  PNCoorChart.m
//  Chart
//
//  Created by 万存 on 16/3/23.
//  Copyright © 2016年 WanCun. All rights reserved.
//

#import "PNCoorChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"



#import "PNChartLabel.h"
#import "PNLineChartData.h"
#import "PNLineChartDataItem.h"
#import <CoreText/CoreText.h>
@interface PNCoorChart () {
    NSMutableArray *_xChartLabels;
    NSMutableArray *_yLeftChartLabels;
    NSMutableArray *_yRightChartLabels;
}
@property (nonatomic) NSMutableArray *chartLineArray;  // Array[CAShapeLayer]
@property (nonatomic) NSMutableArray *chartPointArray; // Array[CAShapeLayer] save the point layer

@property (nonatomic) NSMutableArray *chartPath;       // Array of line path, one for each line.
@property (nonatomic) NSMutableArray *pointPath;       // Array of point path, one for each line
@property (nonatomic) NSMutableArray *endPointsOfPath;      // Array of start and end points of each line path, one for each line
@property (nonatomic) CABasicAnimation *pathAnimation; // will be set to nil if _displayAnimation is NO

// display grade
@property (nonatomic) NSMutableArray *gradeStringPaths;

@property (nonatomic) CALayer *coverLayer ;
- (UIColor *)barColorAtIndex:(NSUInteger)index;

@end
@implementation PNCoorChart

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setupDefaultValues];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupDefaultValues];
    }
    
    return self;
}

- (void)setupDefaultValues
{
    [super setupDefaultValues];
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds   = YES;
    _showLabel           = YES;
    _barBackgroundColor  = PNLightGrey;
    _labelTextColor      = [UIColor grayColor];
    _labelFont           = [UIFont systemFontOfSize:11.0f];
    _xChartLabels        = [NSMutableArray array];
    _yLeftChartLabels    = [NSMutableArray array];
    _yRightChartLabels   = [NSMutableArray array];
    _bars                = [NSMutableArray array];
    _chartLineArray      = [NSMutableArray array];
    _pathPoints          = [NSMutableArray array];
    _endPointsOfPath     = [NSMutableArray array];
    _xLabelSkip          = 1;
    _yLabelSum           = 4;
    _labelMarginTop      = 0;
    _chartMarginLeft     = 25.0;
    _chartMarginRight    = 25.0;
    _chartMarginTop      = 25.0;
    _chartMarginBottom   = 25.0;
    _barRadius           = 2.0;
    _showChartBorder     = NO;
    _chartBorderColor    = PNLightGrey;
    _showLevelLine       = NO;
    _yChartLabelWidth    = 18;
    _rotateForXAxisText  = false;
    _isGradientShow      = YES;
    _isShowNumbers       = YES;
    _yLabelPrefix        = @"";
    _yLabelSuffix        = @"";
    _chartCavanWidth = self.frame.size.width - _chartMarginLeft - _chartMarginRight;
    _chartCavanHeight = self.frame.size.height - _chartMarginBottom - _chartMarginTop;
    _yLabelFormatter = ^(CGFloat yValue){
        return [NSString stringWithFormat:@"%1.f",yValue];
    };
    
    _coverLayer  = [CALayer layer];
    _coverLayer.backgroundColor = [UIColor clearColor].CGColor ;

}
//右边标题
-(void)setYRightLabels:(NSArray *)yRightLabels{
    float sectionHeight = (self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight) / (yRightLabels.count-1);
    
    for (int i = 0; i < yRightLabels.count; i++) {
//        if (_yRightLabels) {
//            float yAsixValue = [_yRightLabels[_yRightLabels.count - i - 1] floatValue];
//            labelText= _yLabelFormatter(yAsixValue);
//        } else {
//            labelText = _yLabelFormatter((float)_yValueMax * ( (_yLabelSum - i) / (float)_yLabelSum ));
//        }
        NSString *labelText = yRightLabels[yRightLabels.count - i - 1];
        PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectZero];
        label.font = _labelFont;
        label.textColor = _labelTextColor;
        [label setTextAlignment:NSTextAlignmentCenter];
        label.text = [NSString stringWithFormat:@"%@%@", labelText, _yLabelSuffix];
        
        [self addSubview:label];
        
        label.frame = (CGRect){self.frame.size.width-_chartMarginRight, sectionHeight * i + _chartMarginTop - kYLabelHeight/2.0, _yChartLabelWidth, kYLabelHeight};
        
        [_yRightChartLabels addObject:label];
    }

    [self getYRightValueMax:yRightLabels] ;
}
#pragma mark -- 获取右坐标最大值
- (void)getYRightValueMax:(NSArray *)yLabels
{
    CGFloat max = [[yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
    
    //ensure max is even
    _YRightValueMax = max ;
//    
//    if (_YRightValueMax == 0) {
//        _YRightValueMax = _yMinValue;
//    }
}
-(void)setYLeftValues:(NSArray *)yLeftValues{
    

    _yLeftValues = yLeftValues;
    //make the _yLabelSum value dependant of the distinct values of yValues to avoid duplicates on yAxis
    
    if (_showLabel) {
        [self __addYCoordinateLabelsValues];
    } else {
        [self processYMaxValue];
    }
}

- (void)processYMaxValue {
    NSArray *yAxisValues = _yLeftLabels ? _yLeftLabels : _yLeftValues;
    _yLabelSum = _yLeftLabels ? _yLeftLabels.count - 1 :_yLabelSum;
    if (_yMaxValue) {
        _yLeftValueMax = _yMaxValue;
    } else {
        [self getYValueMax:yAxisValues];
    }
    
    if (_yLabelSum==4) {
        _yLabelSum = yAxisValues.count;
        (_yLabelSum % 2 == 0) ? _yLabelSum : _yLabelSum++;
    }
    
    
//    
}

#pragma mark - Private Method
#pragma mark - Add Y Label
- (void)__addYCoordinateLabelsValues{
    
    [self viewCleanupForCollection:_yLeftChartLabels];
    
    [self processYMaxValue];
    
    float sectionHeight = (self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight) / _yLabelSum;
    
    for (int i = 0; i <= _yLabelSum; i++) {
        NSString *labelText;
        if (_yLeftLabels) {
            float yAsixValue = [_yLeftLabels[_yLeftLabels.count - i - 1] floatValue];
            labelText= _yLabelFormatter(yAsixValue);
        } else {
            labelText = _yLabelFormatter((float)_yLeftValueMax * ( (_yLabelSum - i) / (float)_yLabelSum ));
        }
        
        PNChartLabel *label = [[PNChartLabel alloc] initWithFrame:CGRectZero];
        label.font = _labelFont;
        label.textColor = _labelTextColor;
        [label setTextAlignment:NSTextAlignmentRight];
        label.text = [NSString stringWithFormat:@"%@%@%@", _yLabelPrefix, labelText, _yLabelSuffix];
        
        [self addSubview:label];
        
        label.frame = (CGRect){0, sectionHeight * i + _chartMarginTop - kYLabelHeight/2.0, _yChartLabelWidth, kYLabelHeight};
        
        [_yLeftChartLabels addObject:label];
    }
}

-(void)updateChartData:(NSArray *)data{
    self.yLeftValues = data;
    [self updateBar];
}

- (void)getYValueMax:(NSArray *)yLabels
{
    CGFloat max = [[yLabels valueForKeyPath:@"@max.floatValue"] floatValue];
    
    //ensure max is even
    _yLeftValueMax = max ;
    
    if (_yLeftValueMax == 0) {
        _yLeftValueMax = _yMinValue;
    }
}

- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    
    if (_xChartLabels) {
        [self viewCleanupForCollection:_xChartLabels];
    }else{
        _xChartLabels = [NSMutableArray new];
    }
    
    _xLabelWidth = (self.frame.size.width - _chartMarginLeft - _chartMarginRight) / [xLabels count];
    
    if (_showLabel) {
        int labelAddCount = 0;
        for (int index = 0; index < _xLabels.count; index++) {
            labelAddCount += 1;
            
            if (labelAddCount == _xLabelSkip) {
                NSString *labelText = [_xLabels[index] description];
                PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0, 0, _xLabelWidth, kXLabelHeight)];
                label.font = _labelFont;
                label.textColor = _labelTextColor;
                [label setTextAlignment:NSTextAlignmentCenter];
                label.text = labelText;
                //[label sizeToFit];
                CGFloat labelXPosition;
                if (_rotateForXAxisText){
                    label.transform = CGAffineTransformMakeRotation(M_PI / 4);
                    labelXPosition = (index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /1.5);
                }
                else{
                    labelXPosition = (index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /2.0 );
                }
                label.center = CGPointMake(labelXPosition,
                                           self.frame.size.height - kXLabelHeight - _chartMarginTop + label.frame.size.height /2.0 + _labelMarginTop);
                labelAddCount = 0;
                
                [_xChartLabels addObject:label];
                [self addSubview:label];
            }
        }
    }
}


- (void)setStrokeColor:(UIColor *)strokeColor
{
    _strokeColor = strokeColor;
}

#pragma  mark -- 计算PNBar高度
- (void)updateBar
{
    
    //Add bars
    CGFloat chartCavanHeight = self.frame.size.height - _chartMarginTop - _chartMarginBottom - kXLabelHeight;
    NSInteger index = 0;
    
    for (NSNumber *valueString in _yLeftValues) {
        
        PNBar *bar;
        
        if (_bars.count == _yLeftValues.count) {
            bar = [_bars objectAtIndex:index];
        }else{
            CGFloat barWidth;
            CGFloat barXPosition;
            
            if (_barWidth) {
                barWidth = _barWidth;
                barXPosition = index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /2.0 - _barWidth /2.0;
            }else{
                barXPosition = index *  _xLabelWidth + _chartMarginLeft + _xLabelWidth * 0.25;
                if (_showLabel) {
                    barWidth = _xLabelWidth * 0.5;
                    
                }
                else {
                    barWidth = _xLabelWidth * 0.6;
                    
                }
            }
            
            bar = [[PNBar alloc] initWithFrame:CGRectMake(barXPosition, //Bar X position
                                                          self.frame.size.height - chartCavanHeight - kXLabelHeight - _chartMarginBottom + _chartMarginTop , //Bar Y position
                                                          barWidth, // Bar witdh
                                                          self.showLevelLine ? chartCavanHeight/2.0:chartCavanHeight)]; //Bar height
            
            //Change Bar Radius
            bar.barRadius = _barRadius;
            
            //Set Bar Animation
            bar.displayAnimated = self.displayAnimated;
            
            //Change Bar Background color
            bar.backgroundColor = _barBackgroundColor;
            //Bar StrokColor First
            if (self.strokeColor) {
                bar.barColor = self.strokeColor;
            }else{
                bar.barColor = [self barColorAtIndex:index];
            }
            
            if (self.labelTextColor) {
                bar.labelTextColor = self.labelTextColor;
            }
            
            // Add gradient
            if (self.isGradientShow) {
                bar.barColorGradientStart = bar.barColor;
            }
            
            //For Click Index
            bar.tag = index;
            
            [_bars addObject:bar];
            [self addSubview:bar];
        }
        
        //Height Of Bar
        float value = [valueString floatValue];
        float grade =fabsf((float)value / (float)_yLeftValueMax);
        
        if (isnan(grade)) {
            grade = 0;
        }
        bar.maxDivisor = (float)_yLeftValueMax;
        bar.grade = grade;
        bar.isShowNumber = self.isShowNumbers;
        CGRect originalFrame = bar.frame;
        NSString *currentNumber =  [NSString stringWithFormat:@"%f",value];
        
        if ([[currentNumber substringToIndex:1] isEqualToString:@"-"] && self.showLevelLine) {
            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI);
            [bar setTransform:transform];
            originalFrame.origin.y = bar.frame.origin.y + bar.frame.size.height;
            bar.frame = originalFrame;
            bar.isNegative = YES;
            
        }
        index += 1;
    }
}
#pragma mark 圆柱
- (void)strokeChart
{
    //Add Labels
    
    [self viewCleanupForCollection:_bars];
    
    
    //Update Bar
    
    [self updateBar];
    
    //Add chart border lines
    
    if (_showChartBorder) {
        _chartBottomLine = [CAShapeLayer layer];
        _chartBottomLine.lineCap      = kCALineCapButt;
        _chartBottomLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartBottomLine.lineWidth    = 1.0;
        _chartBottomLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(_chartMarginLeft, self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMarginRight,  self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartBottomLine.path = progressline.CGPath;
        _chartBottomLine.strokeColor = [_chartBorderColor CGColor];;
        _chartBottomLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartBottomLine];
        
        //Add left Chart Line
        
        _chartLeftLine = [CAShapeLayer layer];
        _chartLeftLine.lineCap      = kCALineCapButt;
        _chartLeftLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLeftLine.lineWidth    = 1.0;
        _chartLeftLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressLeftline = [UIBezierPath bezierPath];
        
        [progressLeftline moveToPoint:CGPointMake(_chartMarginLeft, self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        [progressLeftline addLineToPoint:CGPointMake(_chartMarginLeft,  _chartMarginTop)];
        
        [progressLeftline setLineWidth:1.0];
        [progressLeftline setLineCapStyle:kCGLineCapSquare];
        _chartLeftLine.path = progressLeftline.CGPath;
        _chartLeftLine.strokeColor = [_chartBorderColor CGColor];
        _chartLeftLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLeftLine];
        
//        add rightLine
        
        _chartRightLine = [CAShapeLayer layer];
        _chartRightLine.lineCap      = kCALineCapButt;
        _chartRightLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartRightLine.lineWidth    = 1.0;
        _chartRightLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressRightline = [UIBezierPath bezierPath];
        
        [progressRightline moveToPoint:CGPointMake(self.frame.size.width - _chartMarginRight,
                                                   self.frame.size.height - kXLabelHeight - _chartMarginBottom + _chartMarginTop)];
        [progressRightline addLineToPoint:CGPointMake(self.frame.size.width - _chartMarginRight,  _chartMarginTop)];
        
        [progressRightline setLineWidth:1.0];
        [progressRightline setLineCapStyle:kCGLineCapSquare];
        _chartRightLine.path = progressRightline.CGPath;
        _chartRightLine.strokeColor = [_chartBorderColor CGColor];
        _chartRightLine.strokeEnd = 1.0;
        
        
        [self addBorderAnimationIfNeeded];

        [self.layer addSublayer:_chartRightLine];
        

        
    }
    
    // Add Level Separator Line
    if (_showLevelLine) {
        _chartLevelLine = [CAShapeLayer layer];
        _chartLevelLine.lineCap      = kCALineCapButt;
        _chartLevelLine.fillColor    = [[UIColor whiteColor] CGColor];
        _chartLevelLine.lineWidth    = 1.0;
        _chartLevelLine.strokeEnd    = 0.0;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        [progressline moveToPoint:CGPointMake(_chartMarginLeft, (self.frame.size.height - kXLabelHeight )/2.0)];
        [progressline addLineToPoint:CGPointMake(self.frame.size.width - _chartMarginLeft - _chartMarginRight,  (self.frame.size.height - kXLabelHeight )/2.0)];
        
        [progressline setLineWidth:1.0];
        [progressline setLineCapStyle:kCGLineCapSquare];
        _chartLevelLine.path = progressline.CGPath;
        
        _chartLevelLine.strokeColor = PNLightGrey.CGColor;
        
        [self addSeparatorAnimationIfNeeded];
        _chartLevelLine.strokeEnd = 1.0;
        
        [self.layer addSublayer:_chartLevelLine];
    } else {
        if (_chartLevelLine) {
            [_chartLevelLine removeFromSuperlayer];
            _chartLevelLine = nil;
        }
    }
    
    [self strokeLineChart];
    
}
#pragma mark 折线
-(void)setLineChartData:(NSArray *)data{
    if (data != _lineChartData) {
        
        // remove all shape layers before adding new ones
        for (CALayer *layer in self.chartLineArray) {
            [layer removeFromSuperlayer];
        }
        for (CALayer *layer in self.chartPointArray) {
            [layer removeFromSuperlayer];
        }
        
        self.chartLineArray = [NSMutableArray arrayWithCapacity:data.count];
        self.chartPointArray = [NSMutableArray arrayWithCapacity:data.count];
        
        for (PNLineChartData *chartData in data) {
            // create as many chart line layers as there are data-lines
            CAShapeLayer *chartLine = [CAShapeLayer layer];
            chartLine.lineCap       = kCALineCapButt;
            chartLine.lineJoin      = kCALineJoinMiter;
            chartLine.fillColor     = [[UIColor whiteColor] CGColor];
            chartLine.lineWidth     = chartData.lineWidth;
            chartLine.strokeEnd     = 0.0;
            [self.layer addSublayer:chartLine];
            [self.chartLineArray addObject:chartLine];
            
            // create point
            CAShapeLayer *pointLayer = [CAShapeLayer layer];
            pointLayer.strokeColor   = [[chartData.color colorWithAlphaComponent:chartData.alpha]CGColor];
            pointLayer.lineCap       = kCALineCapRound;
            pointLayer.lineJoin      = kCALineJoinBevel;
            pointLayer.fillColor     = nil;
            pointLayer.lineWidth     = chartData.lineWidth;
            [self.layer addSublayer:pointLayer];
            [self.chartPointArray addObject:pointLayer];
        }
        
        _lineChartData = data;
        
        [self prepareYLabelsWithData:data];
        
        [self setNeedsDisplay];
    }

}
-(void)prepareYLabelsWithData:(NSArray *)data
{
    CGFloat yMax = 0.0f;
    CGFloat yMin = MAXFLOAT;
    NSMutableArray *yLabelsArray = [NSMutableArray new];
    
    for (PNLineChartData *chartData in data) {
        // create as many chart line layers as there are data-lines
        
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            CGFloat yValue = chartData.getData(i).y;
            [yLabelsArray addObject:[NSString stringWithFormat:@"%2f", yValue]];
            yMax = fmaxf(yMax, yValue);
            yMin = fminf(yMin, yValue);
        }
    }
    
    
    // Min value for Y label
    if (yMax < 5) {
        yMax = 5.0f;
    }
    
    if (yMin < 0) {
        yMin = 0.0f;
    }
    
    _lineYMIN = (_lineYFixedValueMin > -FLT_MAX) ? _lineYFixedValueMin : yMin ;
    _lineYMAX = (_lineYFixedValueMax > -FLT_MAX) ? _lineYFixedValueMax : yMax + yMax / 10.0;
    
//    if (_showGenYLabels) {
//        [self setYLabels];
//    }
    
}

-(void) strokeLineChart{
    _chartPath = [[NSMutableArray alloc] init];
    _pointPath = [[NSMutableArray alloc] init];
    _gradeStringPaths = [NSMutableArray array];
    _coverLayer.frame = CGRectMake(_chartMarginLeft,
                                   _chartMarginTop,
                                   self.frame.size.width- _chartMarginLeft-_chartMarginRight,
                                   self.frame.size.height-_chartMarginBottom - kXLabelHeight);
    
    [self calculateChartPath:_chartPath andPointsPath:_pointPath andPathKeyPoints:_pathPoints andPathStartEndPoints:_endPointsOfPath];
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.lineChartData.count; lineIndex++) {
        PNLineChartData *chartData = self.lineChartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *)self.chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *)self.chartPointArray[lineIndex];
        [_coverLayer addSublayer:chartLine];
        [_coverLayer addSublayer:pointLayer];
//        UIGraphicsBeginImageContext(self.frame.size);
        UIGraphicsBeginImageContext(_coverLayer.frame.size);
        // setup the color of the chart line
        if (chartData.color) {
            chartLine.strokeColor = [[chartData.color colorWithAlphaComponent:chartData.alpha]CGColor];
        } else {
            chartLine.strokeColor = [PNGreen CGColor];
            pointLayer.strokeColor = [PNGreen CGColor];
        }
        
        UIBezierPath *progressline = [_chartPath objectAtIndex:lineIndex];
        UIBezierPath *pointPath = [_pointPath objectAtIndex:lineIndex];
        
        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPath.CGPath;
        
        [CATransaction begin];
        
        [chartLine addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        chartLine.strokeEnd = 1.0;
        
        // if you want cancel the point animation, conment this code, the point will show immediately
        if (chartData.inflexionPointStyle != PNLineChartPointStyleNone) {
            [pointLayer addAnimation:self.pathAnimation forKey:@"strokeEndAnimation"];
        }
        
        [CATransaction commit];
        
        NSMutableArray* textLayerArray = [self.gradeStringPaths objectAtIndex:lineIndex];
        for (CATextLayer* textLayer in textLayerArray) {
            CABasicAnimation* fadeAnimation = [self fadeAnimation];
            [textLayer addAnimation:fadeAnimation forKey:nil];
        }
        
        UIGraphicsEndImageContext();
    }

}
-(CABasicAnimation*)fadeAnimation
{
    CABasicAnimation *fadeAnimation = nil;
    if (self.displayAnimated) {
        fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnimation.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnimation.duration = 2.0;
    }
    return fadeAnimation;
}
-(CABasicAnimation *)pathAnimation
{
    if (self.displayAnimated && !_pathAnimation) {
        _pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _pathAnimation.duration = 1.0;
        _pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        _pathAnimation.fromValue = @0.0f;
        _pathAnimation.toValue   = @1.0f;
    }
    return _pathAnimation;
}
#pragma mark -- 折线计算
- (void)calculateChartPath:(NSMutableArray *)chartPath andPointsPath:(NSMutableArray *)pointsPath andPathKeyPoints:(NSMutableArray *)pathPoints andPathStartEndPoints:(NSMutableArray *)pointsOfPath
{
    // Draw each line
    for (NSUInteger lineIndex = 0; lineIndex < self.lineChartData.count; lineIndex++) {
        PNLineChartData *chartData = self.lineChartData[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        
        UIBezierPath *pointPath = [UIBezierPath bezierPath];
        
        
        [chartPath insertObject:progressline atIndex:lineIndex];
        [pointsPath insertObject:pointPath atIndex:lineIndex];
        
        
        
        NSMutableArray* gradePathArray = [NSMutableArray array];
        [self.gradeStringPaths addObject:gradePathArray];
        
        if (!_showLabel) {
            _chartCavanHeight = self.frame.size.height - 2 * _yLabelHeight;
            _chartCavanWidth = self.frame.size.width;
            //_chartMargin = chartData.inflexionPointWidth;
            _xLabelWidth = (_chartCavanWidth / ([_xLabels count] - 1));
        }
        
        NSMutableArray *linePointsArray = [[NSMutableArray alloc] init];
        NSMutableArray *lineStartEndPointsArray = [[NSMutableArray alloc] init];
        int last_x = 0;
        int last_y = 0;
        CGFloat inflexionWidth = chartData.inflexionPointWidth;
        CGFloat marginW = _chartMarginRight ;
        for (NSUInteger i = 0; i < chartData.itemCount; i++) {
            
            yValue = chartData.getData(i).y;
            
            if (!(_lineYMAX - _lineYMIN)) {
                innerGrade = 0.5;
            } else {
                innerGrade = (yValue - _lineYMIN) / (_YRightValueMax - _lineYMIN);
            }
            
            int x = i *  _xLabelWidth + _chartMarginLeft + _xLabelWidth /2.0;
            
            int y = _chartCavanHeight - (innerGrade * _chartCavanHeight) + (_yLabelHeight / 2)  + _chartMarginTop ;
//            - _chartMarginBottom
            
            // Circular point
            if (chartData.inflexionPointStyle == PNLineChartPointStyleCircle) {
                
                CGRect circleRect = CGRectMake(x -inflexionWidth / 2-marginW/2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint circleCenter = CGPointMake(circleRect.origin.x + (circleRect.size.width / 2), circleRect.origin.y + (circleRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth / 2), circleCenter.y)];
                [pointPath addArcWithCenter:circleCenter radius:inflexionWidth / 2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
                
                //jet text display text
                if (chartData.showPointLabel == YES) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:circleCenter width:inflexionWidth withChartData:chartData]];
                }
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) );
                    float last_x1 = last_x -marginW/2+ (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x-marginW/2 - (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
                [self.layer addSublayer:_coverLayer] ;

                
            }
            // Square point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleSquare) {
                
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPath moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y - (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth / 2), squareCenter.y + (inflexionWidth / 2))];
                [pointPath closePath];
                
                // text display text
                if (chartData.showPointLabel == YES) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:squareCenter width:inflexionWidth withChartData:chartData]];
                }
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) );
                    float last_x1 = last_x + (inflexionWidth / 2);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x - (inflexionWidth / 2);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
            }
            // Triangle point
            else if (chartData.inflexionPointStyle == PNLineChartPointStyleTriangle) {
                CGRect squareRect = CGRectMake(x - inflexionWidth / 2-marginW/2, y - inflexionWidth / 2, inflexionWidth, inflexionWidth);
                
                CGPoint startPoint = CGPointMake(squareRect.origin.x,squareRect.origin.y + squareRect.size.height);
                CGPoint endPoint = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2) , squareRect.origin.y);
                CGPoint middlePoint = CGPointMake(squareRect.origin.x + (squareRect.size.width) , squareRect.origin.y + squareRect.size.height);
                
                [pointPath moveToPoint:startPoint];
                [pointPath addLineToPoint:middlePoint];
                [pointPath addLineToPoint:endPoint];
                [pointPath closePath];
                
                
                // text display text
                if (chartData.showPointLabel == YES) {
                    [gradePathArray addObject:[self createPointLabelFor:chartData.getData(i).rawY pointCenter:middlePoint width:inflexionWidth withChartData:chartData]];
                }
                
                if ( i != 0 ) {
                    // calculate the point for triangle
                    float distance = sqrt(pow(x - last_x, 2) + pow(y - last_y, 2) ) * 1.5 ;
                    float last_x1 = last_x-marginW/2 + (inflexionWidth / 2) / distance * (x - last_x);
                    float last_y1 = last_y + (inflexionWidth / 2) / distance * (y - last_y);
                    float x1 = x -marginW/2- (inflexionWidth / 2) / distance * (x - last_x);
                    float y1 = y - (inflexionWidth / 2) / distance * (y - last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                    
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(last_x1, last_y1)]];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
                }
                
                last_x = x;
                last_y = y;
                
                [self.layer addSublayer:_coverLayer] ;

            } else {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
                if(i != chartData.itemCount - 1){
                    [lineStartEndPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
                }
            }
            
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        
        [pathPoints addObject:[linePointsArray copy]];
        [pointsOfPath addObject:[lineStartEndPointsArray copy]];
    }
}
-(CATextLayer*) createPointLabelFor:(CGFloat)grade pointCenter:(CGPoint)pointCenter width:(CGFloat)width withChartData:(PNLineChartData*)chartData
{
    CATextLayer *textLayer = [[CATextLayer alloc]init];
    [textLayer setAlignmentMode:kCAAlignmentCenter];
    [textLayer setForegroundColor:[chartData.pointLabelColor CGColor]];
    [textLayer setBackgroundColor:[[[UIColor whiteColor] colorWithAlphaComponent:0.8] CGColor]];
    [textLayer setCornerRadius:textLayer.fontSize/8.0];
    
    if (chartData.pointLabelFont != nil) {
        [textLayer setFont:(__bridge CFTypeRef)(chartData.pointLabelFont)];
        textLayer.fontSize = [chartData.pointLabelFont pointSize];
    }
    
    CGFloat textHeight = textLayer.fontSize * 1.1;
    CGFloat textWidth = width*8;
    CGFloat textStartPosY;
    
    textStartPosY = pointCenter.y - textLayer.fontSize;
    
    [self.layer addSublayer:textLayer];
    
    if (chartData.pointLabelFormat != nil) {
        [textLayer setString:[[NSString alloc]initWithFormat:chartData.pointLabelFormat, grade]];
    } else {
        [textLayer setString:[[NSString alloc]initWithFormat:_lineYLabelFormat, grade]];
    }
    
    [textLayer setFrame:CGRectMake(0, 0, textWidth,  textHeight)];
    [textLayer setPosition:CGPointMake(pointCenter.x, textStartPosY)];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    return textLayer;
}
- (void)addBorderAnimationIfNeeded
{
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartBottomLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        CABasicAnimation *pathLeftAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathLeftAnimation.duration = 0.5;
        pathLeftAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathLeftAnimation.fromValue = @0.0f;
        pathLeftAnimation.toValue = @1.0f;
        [_chartLeftLine addAnimation:pathLeftAnimation forKey:@"strokeEndAnimation"];
        
        
        CABasicAnimation *pathRightAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathRightAnimation.duration = 0.5;
        pathRightAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathRightAnimation.fromValue = @0.0f;
        pathRightAnimation.toValue = @1.0f;
        [_chartRightLine addAnimation:pathRightAnimation forKey:@"strokeEndAnimation"];
    }
}

- (void)addSeparatorAnimationIfNeeded
{
    if (self.displayAnimated) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = 0.5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = @0.0f;
        pathAnimation.toValue = @1.0f;
        [_chartLevelLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    }
}

- (void)viewCleanupForCollection:(NSMutableArray *)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}


#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yLeftValues count]) {
        return self.strokeColors[index];
    }
    else {
        return self.strokeColor;
    }
}

#pragma mark - Touch detection

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchPoint:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchPoint:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Get the point user touched
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    UIView *subview = [self hitTest:touchPoint withEvent:nil];
    
    if ([subview isKindOfClass:[PNBar class]] && [self.delegate respondsToSelector:@selector(userClickedOnBarAtIndex:)]) {
        [self.delegate userClickedOnBarAtIndex:subview.tag];
    }
}


@end
