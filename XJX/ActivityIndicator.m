//
//  ActivityIndicator.m
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "ActivityIndicator.h"

@interface ActivityIndicator()

@property (nonatomic,strong) UIView *view;

@end

@implementation ActivityIndicator

+ (instancetype)sharedIndicator{
    static ActivityIndicator *indicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicator = [[ActivityIndicator alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return indicator;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = WhiteColor(0, .15);
    }
    return self;
}

- (void)show{
    
    UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading3" ofType:@"gif"]]];
    CGSize size = CGSizeMake([self getW] - 2 * 50, ([self getW] - 2 * 50) * gif.size.height / gif.size.width);
    
    if(!_view){
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 24,24)];
        _view.backgroundColor = WhiteColor(1, 1);
        _view.alpha = 0;
        _view.layer.cornerRadius = 12;
        _view.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.image = gif;
        
        [_view horizontalCenteredOnView:self];
        [_view addSubview:imageView];
        
        [self addSubview:_view];
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.easingType = MMTweenEasingOut;
    anim.functionType = MMTweenFunctionElastic;
    anim.duration = 1.2;
    anim.fromValue = @[@([_view center].y),@([_view getW]),@([_view getH]),@(0.5 * [_view getH]),@(_view.alpha)];
    anim.toValue = @[@(self.center.y),@(size.width),@(size.height),@(5),@(1)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIView *rView = target;
        rView.layer.cornerRadius = [v[3] floatValue];
        [rView setW:[v[1] floatValue]];
        [rView setH:[v[2] floatValue]];
        [rView setCenter:CGPointMake(rView.center.x, [v[0] floatValue])];
        [rView setAlpha:[v[4] floatValue]];
        [_view horizontalCenteredOnView:self];
    };
    [_view pop_addAnimation:anim forKey:@"custom"];
}

- (void)hide{
    [_view pop_removeAllAnimations];
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.easingType = MMTweenEasingOut;
    anim.functionType = MMTweenFunctionExpo;
    anim.duration = .4;
    anim.fromValue = @[@([_view getMinY]),@([_view getW]),@([_view getH]),@(_view.alpha)];
    anim.toValue = @[@(SCREEN_HEIGHT),@(25),@(25),@(0)];
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        UIView *rView = target;
        [rView setY:[v[0] floatValue]];
        [rView setW:[v[1] floatValue]];
        [rView setH:[v[2] floatValue]];
        [rView setAlpha:[v[3] floatValue]];
        [[rView layer] setCornerRadius: 0.5 * [v[2] floatValue]];
        [rView horizontalCenteredOnView:self];
    };
    [anim setCompletionBlock:^(POPAnimation *a, BOOL bl) {
        [_view removeFromSuperview];
        self.view = nil;
        [self removeFromSuperview];
    }];
    [_view pop_addAnimation:anim forKey:@"custom"];
}

@end
