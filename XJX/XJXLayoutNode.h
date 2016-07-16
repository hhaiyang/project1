//
//  XJXLayoutNode.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XJXLayoutNode : NSObject

@property (nonatomic,assign) UIEdgeInsets padding;

- (CGFloat)getWidth;
- (CGFloat)getHeight;
- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view;

- (UIView *)render;

@end
