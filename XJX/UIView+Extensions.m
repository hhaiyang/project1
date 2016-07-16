//
//  UIView+Extensions.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "UIView+Extensions.h"
#import <objc/runtime.h>

static char VIEW_TOUCHED_KEY;

@implementation UIView (Extensions)

@dynamic onViewTouchedHandler;

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setW:(CGFloat)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setH:(CGFloat)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)setXAnimate:(CGFloat)x{
    MMTweenAnimation *anim = [Animator animationWithFromVals:@[@([self getMinX])] toVals:@[@(x)] onAnimating:^(id target, NSArray *currentVals) {
        NSLog(@"%@",currentVals[0]);
        [target setX:[currentVals[0] floatValue]];
    } completion:^{
        
    }];
    [self pop_addAnimation:anim forKey:@"custom"];
}

- (void)setYAnimate:(CGFloat)y{
    MMTweenAnimation *anim = [Animator animationWithFromVals:@[@([self getMinY])] toVals:@[@(y)] onAnimating:^(id target, NSArray *currentVals) {
        [target setY:[currentVals[0] floatValue]];
    } completion:^{
        
    }];
    [self pop_addAnimation:anim forKey:@"custom"];
}

- (void)setWAnimate:(CGFloat)w{
    MMTweenAnimation *anim = [Animator animationWithFromVals:@[@([self getW])] toVals:@[@(w)] onAnimating:^(id target, NSArray *currentVals) {
        [target setW:[currentVals[0] floatValue]];
    } completion:^{
        
    }];
    [self pop_addAnimation:anim forKey:@"custom"];
}

- (void)setHAnimate:(CGFloat)h{
    [self pop_removeAllAnimations];
    MMTweenAnimation *anim = [Animator animationWithFromVals:@[@([self getH])] toVals:@[@(h)] onAnimating:^(id target, NSArray *currentVals) {
        [target setH:[currentVals[0] floatValue]];
    } completion:^{
        
    }];
    [self pop_addAnimation:anim forKey:@"custom"];
}

- (CGFloat)getMaxY{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)getMaxX{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)getMinX{
    return CGRectGetMinX(self.frame);
}

- (CGFloat)getMinY{
    return CGRectGetMinY(self.frame);
}

- (CGFloat)getH{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)getW{
    return CGRectGetWidth(self.frame);
}

- (void)verticalCenteredOnView:(UIView *)view{
    [self setY:(view.bounds.size.height - self.bounds.size.height) / 2.0];
}

- (void)horizontalCenteredOnView:(UIView *)view{
    [self setX:(view.bounds.size.width - self.bounds.size.width) / 2.0];
}

- (void)enableBluredEffect{
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    [visualEffectView setFrame:self.bounds];
    [self addSubview:visualEffectView];
}

- (void)debugMode{
    self.backgroundColor = [UIColor redColor];
}

- (void)setOnViewTouchedHandler:(onViewTouchEventFired)onViewTouchedHandler{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &VIEW_TOUCHED_KEY, onViewTouchedHandler, OBJC_ASSOCIATION_COPY);
}

- (onViewTouchEventFired)onViewTouchedHandler{
    return objc_getAssociatedObject(self, &VIEW_TOUCHED_KEY);
}

- (void)touched:(UITapGestureRecognizer *)gesture{
    if(self.onViewTouchedHandler){
        self.onViewTouchedHandler(gesture.view);
    }
}

/*- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.onViewTouchedHandler){
        self.onViewTouchedHandler(touches,event);
    }
}*/

@end
