//
//  VolumeMetersView.m
//  JIMTest
//
//  Created by ios2 on 2017/11/30.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "VolumeMetersView.h"

@implementation VolumeMetersView{
    CAShapeLayer *layer1;
    CAShapeLayer *layer2;
    CAShapeLayer *layer3;
    CAShapeLayer *layer4;
    CAShapeLayer *layer5;
}

//用于显示音量大小的View
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        layer1 = [CAShapeLayer layer];
        layer1.fillColor = [UIColor yellowColor].CGColor;
        layer1.opacity = 0.7;
     
        
        //layer2
        layer2 = [CAShapeLayer layer];
        layer2.fillColor = [UIColor magentaColor].CGColor;
        layer2.opacity = 0.7;
        
        //layer3
        layer3 = [CAShapeLayer layer];
        layer3.fillColor = [UIColor orangeColor].CGColor;
        layer3.opacity = 0.7;
 
        
        //layer4
        layer4 = [CAShapeLayer layer];
        layer4.fillColor = [UIColor redColor].CGColor;
        layer4.opacity = 0.7;
        
        //layer5
        layer5 = [CAShapeLayer layer];
        layer5.fillColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1].CGColor;
        layer5.opacity = 0.7;
        [self.layer addSublayer:layer5];
        [self.layer addSublayer:layer1];
        [self.layer addSublayer:layer2];
        [self.layer addSublayer:layer4];
        [self.layer addSublayer:layer3];
        
    }
    return self;
}


-(void)changeVoiceValue:(CGFloat)value
{
    value = 3 *value;

    if (value>1.5f)
    {
        value = 1.50f;
    }
    
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    CGFloat controlY1 =height-(value*height)*0.4;
    CGFloat controlY2 = height-((value*height))*1.2;
    //中间的最大值
    CGFloat controlY3 = height-((value*height))*1.5;
    CGFloat controlY4 =height-((value*height))*0.9;
    CGFloat controlY5 = height-((value*height))*0.7;
    
    //------------------起始点----------------------
    
    CGFloat space =  width/6.0f;
    
    CGPoint start1 = (CGPoint){0,height};
    CGPoint start2 = (CGPoint){space*1,height};
    CGPoint start3 = (CGPoint){space*2,height};
    CGPoint start4 = (CGPoint){space*3,height};
    CGPoint start5 = (CGPoint){space*4,height};
    //------------------结束点----------------------
    CGPoint endPoint1 = (CGPoint){space*2,height};
    CGPoint endPoint2 = (CGPoint){space*3,height};
    CGPoint endPoint3 = (CGPoint){space*4,height};
    CGPoint endPoint4 = (CGPoint){space*5,height};
    CGPoint endPoint5 = (CGPoint){space*6,height};
    //------------------控制点----------------------
    CGPoint controlPoint1 = (CGPoint){space*1,controlY1};
    CGPoint controlPoint2 = (CGPoint){space*2,controlY2};
    CGPoint controlPoint3 = (CGPoint){space*3,controlY3};
    CGPoint controlPoint4 = (CGPoint){space*4,controlY4};
    CGPoint controlPoint5 = (CGPoint){space*5,controlY5};
    
    layer1.path = [self createBezierPathWithStartPoint:start1 endPoint:endPoint1 controlPoint:controlPoint1].CGPath;
    
    layer2.path = [self createBezierPathWithStartPoint:start2 endPoint:endPoint2 controlPoint:controlPoint2].CGPath;
    
    layer3.path = [self createBezierPathWithStartPoint:start3 endPoint:endPoint3 controlPoint:controlPoint3].CGPath;
    
    layer4.path = [self createBezierPathWithStartPoint:start4 endPoint:endPoint4 controlPoint:controlPoint4].CGPath;
    
    layer5.path = [self createBezierPathWithStartPoint:start5 endPoint:endPoint5 controlPoint:controlPoint5].CGPath;
}

//-------------根据返回音量返回实时的曲线----------------------
-(UIBezierPath*)createBezierPathWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint{
    
    UIBezierPath* BezierPath = [UIBezierPath bezierPath];
    [BezierPath moveToPoint: startPoint];
    [BezierPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    return BezierPath;
}

@end
