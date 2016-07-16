//
//  Animator.h
//  XJX
//
//  Created by Cai8 on 16/2/19.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onAnimating)(id target,NSArray *currentVals);
typedef void (^onTweenAnimationDone)();

@interface Animator : NSObject

+ (MMTweenAnimation *)animationWithFromVals:(NSArray *)fromVals toVals:(NSArray *)toVals onAnimating:(onAnimating)animating completion:(onTweenAnimationDone)completion;

@end
