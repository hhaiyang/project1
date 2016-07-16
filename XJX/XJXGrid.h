//
//  XJXGrid.h
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XJXBrick.h"

typedef void (^onGridItemSelected)(XJXBrick *item);

@interface XJXGrid : XJXLayoutNode

@property (nonatomic,assign) int NUM_HORI;
@property (nonatomic,assign) int ITEM_MARGIN;

@property (nonatomic,assign) CGFloat brickWidth;
@property (nonatomic,assign) CGFloat brickHeight;

@property (nonatomic,strong) NSMutableArray *bricks;

@property (nonatomic,copy) onGridItemSelected onItemSelected;

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view;

- (UIView *)render;

- (void)clean;

@end
