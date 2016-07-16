//
//  ProgressView.m
//  XJX
//
//  Created by Cai8 on 16/2/12.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ProgressView.h"

#define pi 3.14159265359
#define DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

@interface ProgressView()

@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,strong) CAShapeLayer *trackLayer;

@end

@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initParams];
        [self initLayer];
    }
    return self;
}

- (void)initParams{
    self.lineWidth = 2.0;
    self.lineColor = [Theme defaultTheme].highlightTextColor;
    self.trackColor = WhiteColor(.90, 1);
}

- (void)layoutSubviews{
    /*self.shapeLayer.frame = self.bounds;
    self.trackLayer.frame = self.bounds;
    self.shapeLayer.path = [self progressPath].CGPath;
    self.trackLayer.path = [self trackPath].CGPath;*/
}

- (void)initLayer{
    self.shapeLayer = [CAShapeLayer layer];
    self.trackLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.trackLayer.frame = self.bounds;
    
    self.shapeLayer.strokeColor = self.lineColor.CGColor;
    self.trackLayer.strokeColor = self.trackColor.CGColor;
    
    self.shapeLayer.fillColor = self.trackLayer.fillColor = [UIColor clearColor].CGColor;
    self.shapeLayer.lineCap = self.trackLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = self.trackLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = self.trackLayer.lineWidth = self.lineWidth;
    self.shapeLayer.path = [self progressPath].CGPath;
    self.trackLayer.path = [self trackPath].CGPath;
    self.shapeLayer.strokeStart = 0;
    
    [self.layer addSublayer:self.trackLayer];
    [self.layer addSublayer:self.shapeLayer];
}

- (void)setProgress:(CGFloat)progress customParamsFrom:(NSArray *)customParams customParamsTo:(NSArray *)customParamsTo{
    NSMutableArray *fromValue = [@[@(self.shapeLayer.strokeEnd)] mutableCopy];
    NSMutableArray *toValue = [@[@(progress)] mutableCopy];
    
    [fromValue addObjectsFromArray:customParams];
    [toValue addObjectsFromArray:customParamsTo];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.duration = 0.8;
    anim.fromValue = fromValue;
    anim.toValue = toValue;
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        CAShapeLayer *shapeLayer = (CAShapeLayer *)target;
        shapeLayer.strokeEnd = [v[0] floatValue];
        
        if(self.progressingHandler){
            self.progressingHandler(v);
        }
        
    };
    [anim setCompletionBlock:^(POPAnimation *ani, BOOL bl) {
        [self.shapeLayer pop_removeAllAnimations];
    }];
    [self.shapeLayer pop_addAnimation:anim forKey:@"custom"];
}

- (UIBezierPath *)progressPath{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.shapeLayer.bounds.size.width / 2) startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(45) clockwise:YES];
    return path;
}

- (UIBezierPath *)trackPath{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.shapeLayer.bounds.size.width / 2) startAngle:DEGREES_TO_RADIANS(135) endAngle:DEGREES_TO_RADIANS(45) clockwise:YES];
    return path;
}


@end
