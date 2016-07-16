//
//  UIView+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^onViewTouchEventFired)(UIView *touchedView);

@interface UIView (Extensions)

@property (nonatomic,copy) onViewTouchEventFired onViewTouchedHandler;;

- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setW:(CGFloat)w;
- (void)setH:(CGFloat)h;

- (void)setXAnimate:(CGFloat)x;
- (void)setYAnimate:(CGFloat)y;
- (void)setWAnimate:(CGFloat)w;
- (void)setHAnimate:(CGFloat)h;

- (void)enableBluredEffect;

- (CGFloat)getMaxY;
- (CGFloat)getMaxX;
- (CGFloat)getMinX;
- (CGFloat)getMinY;
- (CGFloat)getW;
- (CGFloat)getH;

- (void)horizontalCenteredOnView:(UIView *)view;

- (void)verticalCenteredOnView:(UIView *)view;

- (void)debugMode;

@end
