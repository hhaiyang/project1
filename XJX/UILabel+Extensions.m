//
//  UILabel+Extensions.m
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import "UILabel+Extensions.h"

@implementation UILabel (Extensions)

- (void)recalculateSize{
    [self recalculateSizeWithConstraintSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)];
}

- (void)recalculateSizeWithConstraintSize:(CGSize)size{
    if(self.attributedText){
        CGSize newSize = [self.attributedText size];
        [self setH:MIN(newSize.height,size.height)];
        [self setW:MIN(newSize.width,size.width)];
    }
    else{
        CGSize newSize = [self.text sizeWithFont:self.font constrainToSize:size];
        [self setH:newSize.height];
        [self setW:newSize.width];
    }
}

- (void)recalculateSizeWithPrice:(CGFloat)price font:(UIFont *)font symbolFont:(UIFont *)symbolFont{
    NSMutableAttributedString *priceval = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%.2lf",price] attributes:@{NSFontAttributeName : font,
                                                                                                                                                     NSForegroundColorAttributeName : [Theme defaultTheme].highlightTextColor}];
    [priceval addAttribute:NSFontAttributeName value:symbolFont range:NSMakeRange(0, 1)];
    CGSize size = [priceval size];
    [self setW:size.width];
    [self setH:size.height];
    
    self.attributedText = priceval;
}

- (void)recalculateSizeWithPrice:(CGFloat)price{
    [self recalculateSizeWithPrice:price font:[Theme defaultTheme].h2Font symbolFont:[Theme defaultTheme].normalTextFont];
}

- (CGFloat)getSingleLineHeight{
    CGSize size = [@"我" sizeWithFont:self.font];
    return size.height;
}

@end
