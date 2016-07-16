//
//  Animator.m
//  XJX
//
//  Created by Cai8 on 16/2/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "Animator.h"

@implementation Animator

+ (MMTweenAnimation *)animationWithFromVals:(NSArray *)fromVals toVals:(NSArray *)toVals onAnimating:(onAnimating)animating completion:(onTweenAnimationDone)completion{
    MMTweenAnimation *anim = [MMTweenAnimation animation];
    anim.easingType = MMTweenEasingOut;
    anim.functionType = MMTweenFunctionExpo;
    anim.duration = 0.4;
    anim.fromValue = fromVals;
    anim.toValue = toVals;
    anim.animationBlock = ^(double c,   //current time offset(0->duration)
                            double d,   //duration
                            NSArray *v, //current value
                            id target,
                            MMTweenAnimation *animation
                            ){
        if(animating){
            animating(target,v);
        }
    };
    [anim setCompletionBlock:^(POPAnimation *an, BOOL bl) {
        if(completion){
            completion();
        }
    }];
    return anim;
}

@end
