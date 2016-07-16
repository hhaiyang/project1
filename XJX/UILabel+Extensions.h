//
//  UILabel+Extensions.h
//  XJX
//
//  Created by Cai8 on 16/1/16.
//  Copyright © 2016年 Cai8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extensions)

- (void)recalculateSize;

- (void)recalculateSizeWithConstraintSize:(CGSize)size;

- (void)recalculateSizeWithPrice:(CGFloat)price;
- (void)recalculateSizeWithPrice:(CGFloat)price font:(UIFont *)font symbolFont:(UIFont *)symbolFont;

- (CGFloat)getSingleLineHeight;

@end
