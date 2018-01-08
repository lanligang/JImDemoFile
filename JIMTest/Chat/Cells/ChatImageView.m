//
//  ChatImageView.m
//  JIMTest
//
//  Created by ios2 on 2017/12/6.
//  Copyright © 2017年 石家庄光耀. All rights reserved.
//

#import "ChatImageView.h"

@interface ChatImageView ()
{
    //内容图层
       CALayer      *_contentLayer;
    //剪切图层
      CAShapeLayer *_maskLayer;
}
@end

@implementation ChatImageView{
    
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setUplayer];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.state==UIGestureRecognizerStateEnded)
    {
        if (self.didSeletedAction) {
           _didSeletedAction(self);
        }
    }
}

-(void)setUplayer
{
    _maskLayer = [CAShapeLayer layer];

    _contentLayer = [CALayer layer];
    [self.layer addSublayer:_contentLayer];
}

-(void)configerWithImageSize:(CGSize)size andIsRight:(BOOL)isRight
{
    _contentLayer.frame = self.bounds;
    _maskLayer.frame = self.bounds;
    _maskLayer.path = [self findPathWithImageSize:size andIsRight:isRight].CGPath;
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _contentLayer.mask = _maskLayer;

}

-(UIBezierPath *)findPathWithImageSize:(CGSize)size andIsRight:(BOOL)isRight
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat arrowSpace = 8.0f;//箭头的距离
    CGFloat arrowYSpace = 10.0f;//竖向的距离
    CGFloat arrowHeight = 6;//箭头高度
   // CGFloat radius = 4.0f; 角度
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGPoint point1 = CGPointZero;
    CGPoint point2 = CGPointZero;
    CGPoint point3 = CGPointZero;
    CGPoint point4 = CGPointZero;
    CGPoint point5 = CGPointZero;
    CGPoint point6 = CGPointZero;
    CGPoint point7 = CGPointZero;

    if (isRight) {
        
        point1 = (CGPoint){0,0};
        point2 = (CGPoint){width-arrowSpace,0};
        
        point3 = (CGPoint){width-arrowSpace,arrowYSpace};
        
        point4 = (CGPoint){width,arrowYSpace+(arrowHeight/2.0f)};
        
        point5 = (CGPoint){width-arrowSpace,arrowYSpace+arrowHeight};
        
        point6 = (CGPoint){width-arrowSpace,height};
        point7 = (CGPoint){0,height};
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
        [path addLineToPoint:point4];
        [path addLineToPoint:point5];
        [path addLineToPoint:point6];
        [path addLineToPoint:point7];
        [path closePath];
        
    }else{
        point1 = (CGPoint){arrowSpace,0};
        point2 = (CGPoint){width,0};
        point3 = (CGPoint){width,height};
        
        point4 = (CGPoint){arrowSpace,height};
        
        point5 = (CGPoint){arrowSpace,arrowYSpace+arrowHeight};
        
        point6 = (CGPoint){0,arrowYSpace+(arrowHeight/2.0f)};
        
        point7 = (CGPoint){arrowSpace,arrowYSpace};
        [path moveToPoint:point1];
        [path addLineToPoint:point2];
        [path addLineToPoint:point3];
        [path addLineToPoint:point4];
        [path addLineToPoint:point5];
        [path addLineToPoint:point6];
        [path addLineToPoint:point7];
        [path closePath];
    }
    return path;
}

- (void)setImage:(UIImage *)image
{
    _contentLayer.contents = (id)image.CGImage;
}


@end
