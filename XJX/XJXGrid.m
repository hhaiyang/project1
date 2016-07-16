//
//  XJXGrid.m
//  XJX
//
//  Created by Cai8 on 16/1/8.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "XJXGrid.h"

@implementation XJXGrid{
    UIView *renderView;
}
@synthesize NUM_HORI,ITEM_MARGIN;

- (instancetype)init{
    if(self = [super init]){
        NUM_HORI = 2;
        ITEM_MARGIN = 15;
        
        self.padding = UIEdgeInsetsMake([Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI, [Theme defaultTheme].THEMING_EDGE_PADDING_VETI, [Theme defaultTheme].THEMING_EDGE_PADDING_HORI);
    }
    return self;
}

- (UIView *)render{
    if(!renderView){
        renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self getWidth], [self getHeight])];
        __block CGFloat y_offset = self.padding.top;
        __block CGFloat x_offset = self.padding.left;
        CGFloat brick_width = ((renderView.bounds.size.width - self.padding.left - self.padding.right) - (NUM_HORI - 1) * ITEM_MARGIN) / NUM_HORI;
        
        CGFloat brick_height = brick_width * (([UIScreen mainScreen].bounds.size.width > 320 || NUM_HORI == 1) ?  (9.0 / 16.0) : (3.0 / 4.0));
        
        [_bricks enumerateObjectsUsingBlock:^(XJXBrick *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.borderRadius = 5;
            obj.width = self.brickWidth == 0 ? brick_width : self.brickWidth;
            obj.height = self.brickHeight == 0 ? brick_height : self.brickHeight;
            obj.touchedHandler = ^(XJXBrick *brick){
                [self onBrickTouched:brick];
            };
            [obj renderOnPoint:CGPointMake(x_offset, y_offset) onView:renderView];
            
            if((idx + 1) % NUM_HORI == 0){
                x_offset = self.padding.left;
                y_offset += obj.height + ITEM_MARGIN;
            }
            else{
                x_offset += obj.width + ITEM_MARGIN;
            }
        }];
    }
    return renderView;
}

- (void)clean{
    renderView = nil;
}

- (void)onBrickTouched:(XJXBrick *)brick{
    if(_onItemSelected){
        _onItemSelected(brick);
    }
}

- (CGFloat)getWidth{
    return SCREEN_WIDTH;
}

- (CGFloat)getHeight{
    CGFloat brick_width = self.brickWidth == 0 ? ((SCREEN_WIDTH - self.padding.left - self.padding.right) - (NUM_HORI - 1) * ITEM_MARGIN) / NUM_HORI : self.brickWidth;
    
    CGFloat brick_height = self.brickHeight == 0 ? brick_width * (([UIScreen mainScreen].bounds.size.width > 320 || NUM_HORI == 1) ?  (9.0 / 16.0) : (3.0 / 4.0)) : self.brickHeight;
    CGFloat height = (round((_bricks.count * 1.0f) /(NUM_HORI * 1.0f)) - 1) * ITEM_MARGIN +
           (round((_bricks.count * 1.0f) /(NUM_HORI * 1.0f))) * brick_height + self.padding.top + self.padding.left;
    return height;
}

- (void)renderOnPoint:(CGPoint)point onView:(UIView *)view{
    [[self render] setX:point.x];
    [[self render] setY:point.y];
}

@end
