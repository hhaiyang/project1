//
//  UIButton+Extensions.m
//  XJX
//
//  Created by Cai8 on 16/1/20.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

- (void)recalculateSize{
    [self recalculateSizeWithConstraintSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
}

- (void)recalculateSizeWithConstraintSize:(CGSize)size{
    CGSize newSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainToSize:size];
    [self setH:newSize.height];
    [self setW:newSize.width];
}

@end
