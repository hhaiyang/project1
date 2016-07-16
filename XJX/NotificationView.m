//
//  NotificationView.m
//  XJX
//
//  Created by Cai8 on 16/1/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

+ (instancetype)sharedView{
    static NotificationView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[NotificationView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
    });
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
        [self registerEvents];
    }
    return self;
}

- (void)initUI{
    
    self.backgroundColor = [Theme defaultTheme].schemeColor;
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake([Theme defaultTheme].THEMING_EDGE_PADDING_HORI, 0, 40, 40)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.layer.masksToBounds = YES;
    [_imageView verticalCenteredOnView:self];
    
    _titleLabel = [UIControlsUtils labelWithTitle:@"" color:WhiteColor(1, 1) font:[Theme defaultTheme].subTitleFont textAlignment:NSTextAlignmentLeft];
    _titleLabel.numberOfLines = 2;
    [_titleLabel setX:[_imageView getMaxX] + 5];
    [_titleLabel setY:0];
    [_titleLabel setH:[self getH]];
    [_titleLabel setW:[self getW] - [_titleLabel getMinX]];
    
    [self addSubview:_titleLabel];
    [self addSubview:_imageView];
}

- (void)registerEvents{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)rec{
    [self hide];
}

- (void)show{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    if(self.superview)
        return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.fromValue = @[@(self.alpha),@([self getMinY])];
    anim.toValue = @[@(1),@(SCREEN_HEIGHT - 50)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        rView.alpha = [v[0] floatValue];
        [rView setY:[v[1] floatValue]];
    };
    [anim setCompletionBlock:^(POPAnimation *am, BOOL bl) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:3];
    }];
    [self pop_addAnimation:anim forKey:@"customanimation"];
}

- (void)hide{
    if(!self.superview)
        return;
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.functionType = MMTweenFunctionExpo;
    anim.easingType = MMTweenEasingOut;
    anim.fromValue = @[@(self.alpha),@([self getMinY])];
    anim.toValue = @[@(0),@(SCREEN_HEIGHT)];
    anim.animationBlock = ^(double c,double d,NSArray *v,id target,MMTweenAnimation *animation){
        UIView *rView = target;
        rView.alpha = [v[0] floatValue];
        [rView setY:[v[1] floatValue]];
    };
    [anim setCompletionBlock:^(POPAnimation *a, BOOL bl) {
        [self removeFromSuperview];
    }];
    [self pop_addAnimation:anim forKey:@"customanimation"];
}

@end
