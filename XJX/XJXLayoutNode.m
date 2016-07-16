//
//  XJXLayoutNode.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXLayoutNode.h"

@implementation XJXLayoutNode

- (UIView *)render{
    return nil;
}

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    UIView *renderView = [self render];
    [renderView setX:point.x];
    [renderView setY:point.y];
    [view addSubview:renderView];
}
- (CGFloat)getWidth{return SCREEN_WIDTH;}
- (CGFloat)getHeight{return 0;}

@end
